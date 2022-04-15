import numpy as np
import h5py
from typing import List, Union
import enum
from scipy.signal.windows import kaiser
from scipy.stats import mode
from scipy.fft import fft, ifft, fftshift
from pathlib import Path

import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable
import matplotlib.animation as animation

from libISAR.isar_utils import get_rcs_phase_hwb, getCpxData, findNextPowerOf2


class dotdict(dict):
    """dot.notation access to dictionary attributes"""
    __getattr__ = dict.get
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__delitem__


class PROCESS_TYPE(enum.Enum):
    TIME = int(0)
    ANGLE = int(1)


class RDI:
    c = 299792458

    proc_type = PROCESS_TYPE.TIME
    period = 50.0
    periodAngle = 360
    anglePerImage = 6.03
    shiftFactor = 0.2
    thinFactor = 1.0
    numImgsOutput = 200
    angle_per_img = 0.1
    timePerImage = period / 25
    kaiser_beta = 3*np.pi
    output_dir = Path("X:/isar_img_ml/animations")
    doPlots = True

    def __init__(self,
                 rcs: np.ndarray = np.array([]),
                 phase: np.ndarray = np.array([]),
                 times: Union[List[float], np.ndarray] = np.array([]),
                 center_freq: float = 0.0,
                 rng_gate_spc: np.ndarray = np.array([0.0])):

        self.rcs = rcs
        self.phase = phase
        self.rcs_noisy = np.zeros(rcs.shape)
        self.phase_noisy = np.zeros(phase.shape)

        self.pulse_times = times
        self.cf = center_freq
        self.rng_gate_spc = rng_gate_spc
        self.__rangeScale = self.rng_gate_spc[0]
        self.images = []
        self.startTime = times[0]

        self.__imgStartTimes = []
        self.__imgStopTimes = []
        self.__isar_idx: List[int] = []
        self.__start_angle = 0.0
        self.__targetAA = np.zeros(self.rcs.shape)
        self.__pulseAngles = np.zeros(self.rcs.shape)

        # keep as a list to not exclude the possibility that each image has a different number of gates
        # waveform changes during an event could cause something like this to occur
        self.ngates = []

        self.isar_img_files = []
        self.plot_figs = []
        self.current_img = None
        self.current_idx = int(0)

        # for private use of bookeeping what the current image is during iteration
        self.__img_iter = None
        self.__img_idx = int(0)

    @classmethod
    def from_hwb_file(cls, hwb_filename, isBistatic=False):
        if not isBistatic:
            fh5 = h5py.File(hwb_filename, 'r')

            time_xmit = fh5['observation_headers']['time_xmit']
            #n_sample = fh5['n_sample']
            rng_gate_spc = fh5['observation_headers']['rng_gate_spc']  # [m]
            if np.isclose(rng_gate_spc[0], 0):
                rng_gate_spc = np.array([fh5['file_header']['rng_gate_spc']])

            center_freq = fh5['file_header']['center_freq']  # [MHz]

            rcs, phase = get_rcs_phase_hwb(fh5)

            return cls(rcs, phase, time_xmit, center_freq, rng_gate_spc)


    def _getIsarIndeces(self, img_num: int):

        # output array of indices
        indices = []

        fileNumPulses = len(self.pulse_times)
        fileStartTime = self.pulse_times[0]
        fileStopTime = self.pulse_times[-1]
        numPulsesOut = 0

        imgStartTime = 0

        if RDI.proc_type == PROCESS_TYPE.TIME:
            imgStartTime = self.startTime + float(img_num) * RDI.shiftFactor * RDI.timePerImage

        ## dont think I am going to use this feature, going to keep it unfinished for later development
        elif RDI.proc_type == PROCESS_TYPE.ANGLE:
            stopAngle = self.__start_angle + RDI.angle_per_img

        self.__imgStartTimes.append(imgStartTime)

        firstIndex = np.argwhere(self.pulse_times >= imgStartTime)[0]
        if len(firstIndex)>0:
            idx_first_unpacked = firstIndex[0]
            indices.append(idx_first_unpacked)
        else:
            indices.append(int(0))

        if self.pulse_times[indices[0]] + RDI.timePerImage > fileStopTime:
            numPulsesOut = 0
            return numPulsesOut, indices
        thinned_idx = np.arange(indices[0]+RDI.thinFactor, fileNumPulses, RDI.thinFactor).astype(int)
        thinned_window = self.pulse_times[thinned_idx]
        idx_window = thinned_window <= imgStartTime + RDI.timePerImage
        if len(idx_window)>0 and idx_window is not None:
            indices = indices + list(thinned_idx[idx_window])
        else:
            idx_window = []

        numPulsesOut = len(indices)
        return numPulsesOut, indices

    def _preCountNumImages(self):

        fileStartTime = self.pulse_times[0]
        fileStopTime = self.pulse_times[-1]
        totalProcessTime = fileStopTime - fileStartTime

        imgNum = 0
        totalPulses = 0

        while True:
            numPulsesOut, indices = self._getIsarIndeces(imgNum)
            if numPulsesOut == 0:
                break

            imgNum += 1
            totalPulses = totalPulses + numPulsesOut

            if self.pulse_times[indices[-1]] > self.startTime + totalProcessTime:
                break

        return imgNum


    def _calcAngles(self, pulseIdx: Union[List[int], np.ndarray]):

        if self.proc_type == PROCESS_TYPE.TIME:
            refTime = (self.pulse_times[pulseIdx[0]] + self.pulse_times[pulseIdx[-1]]) / 2
            self.__pulseAngles = 360.0 * (self.pulse_times[pulseIdx] - refTime) / self.period
        elif self.proc_type == PROCESS_TYPE.ANGLE:
            refAngle = (self.__targetAA[pulseIdx[0]] + self.__targetAA[pulseIdx[-1]])
            self.__pulseAngles = self.__targetAA[pulseIdx] - refAngle

    def _runImageProgram(self, imgNum:int):

        _, pulseIdx = self._getIsarIndeces(imgNum)
        C = getCpxData(self.rcs, self.phase, pulseIdx)
        npulses, ngates = C.shape
        self.ngates.append(ngates)

        w = kaiser(npulses, RDI.kaiser_beta)
        w = w * npulses / np.sum(w)
        C = C * w[:, np.newaxis]

        nfft_dopp = findNextPowerOf2(npulses)
        nfft_dopp = 256 if nfft_dopp < 256 else nfft_dopp

        # compute the range window
        self._calcAngles(pulseIdx)
        delT = self.pulse_times[pulseIdx[-1]] - self.pulse_times[pulseIdx[0]]
        # get the center frequency in hz
        f_c = self.cf * 1e6
        rng_window = ngates * self.__rangeScale
        rel_range = np.linspace(-rng_window/2, rng_window/2, ngates)

        # calc doppler scales and cross range window
        doppScale = npulses / (delT*nfft_dopp)
        rangeRateScale = doppScale * RDI.c / (2.0*f_c)
        processingAngle = self.__pulseAngles[-1] - self.__pulseAngles[0]
        crossRangeScale = (rangeRateScale * delT) / (np.deg2rad(processingAngle))
        wavelength = RDI.c / f_c
        crossRangeScale = doppScale*wavelength*self.period / (4*np.pi)
        x_rng_window = crossRangeScale * nfft_dopp
        cross_range = np.linspace(-x_rng_window/2, x_rng_window/2, nfft_dopp)

        # Generate ISAR Plot
        RD = fft(C, nfft_dopp, 0)
        # shift pulses to center via fft shift
        RD = fftshift(RD, 0) / npulses

        centerImgTime = (self.pulse_times[pulseIdx[0]] + self.pulse_times[pulseIdx[-1]]) / 2
        self.__imgStopTimes.append(self.pulse_times[pulseIdx[-1]])

        ## we are assuming that the center gate is 0 for this project, consider calculating this in the future
        self.images.append(dotdict({"img": RD, "time": centerImgTime, "rel_range": rel_range, "cross_range": cross_range,
                                    "nfft": nfft_dopp, "imgStartTime": self.__imgStartTimes[-1], "imgStopTime": self.__imgStopTimes[-1],
                                    "cgDopplerBin": 0, "cgRangeBin": 0, "procAngle": processingAngle,
                                    "rangeScale": self.__rangeScale, "crossRangeScale": crossRangeScale}))

        if self.doPlots:

            plotTime = "IMG Program: Center Time = " + str(centerImgTime)
            fig = RDI.genIsarPlot(RD, cross_range, rel_range, plotTime, "Cross Range (m)", "Range (m)")

            self.plot_figs.append(fig)


    def __reset_iter(self):
        if len(self.images) > 0:
            self.__img_iter = iter(self.images)
            self.__img_idx = 0
            self.current_idx = 0

    def generate_isar(self):

        numImages = self._preCountNumImages()
        numImages = self.numImgsOutput if numImages > self.numImgsOutput else numImages

        for i in range(numImages):
            # generate RDI
            self._runImageProgram(i)

        self.__reset_iter()
        #print("Image Stack Generated")
        plt.close('all')


    def _init_plot_params(self, fig, ax, isarType:str ="rd"):

        plt.rcParams.update({'font.size': 12, 'font.weight': 'bold', 'font.family':'Arial'})

        divider = make_axes_locatable(ax)
        cax = divider.append_axes('right', size='5%', pad=0.05)

        return cax


    def setNextImg(self):
        gotNextImg = True
        try:
            self.current_img = next(self.__img_iter)
            self.current_idx = self.__img_idx
            self.__img_idx += 1
        except StopIteration:
            gotNextImg = False

        return gotNextImg

    @staticmethod
    def genIsarPlot(img:np.ndarray,
                    crossRange:np.ndarray,
                    relRange:np.ndarray,
                    plotTitle,
                    x_title:str="Cross Range",
                    y_title:str="Range",
                    isarType:str="RD",
                    output_filename: Path = None)->plt.figure:

        plt.rcParams.update({'font.size': 12, 'font.weight': 'bold', 'font.family': 'Arial'})
        fig = plt.figure()
        ax = fig.add_subplot(111)
        divider = make_axes_locatable(ax)
        cax = divider.append_axes('right', size='5%', pad=0.05)

        #set the size of the figure so that it is consistent

        dB = [-60, 10]
        im = None

        if isarType.lower() == "bpa":
            im = ax.imshow(20.0*np.log10(np.fliplr(np.abs(img.T))),
                      cmap="viridis",
                      extent=[crossRange[0], crossRange[-1], relRange[0], relRange[-1]],
                      vmin=dB[0], vmax=dB[1])
        elif isarType.lower() == "rd":
            im = ax.imshow(20.0*np.log10(np.abs(img.T)),
                      cmap="viridis",
                      extent=[crossRange[0], crossRange[-1], relRange[0], relRange[-1]],
                      vmin=dB[0], vmax=dB[1])

        ax.set_aspect('auto')
        ax.set_title(plotTitle)
        ax.set_xlabel(x_title)
        ax.set_ylabel(y_title)

        fig.colorbar(im, cax=cax, orientation='vertical')
        plt.jet()

        return fig

    def save_figs(self, image_desc: str):
        for i, fig in enumerate(self.plot_figs):
            if fig is not None:
                basename = image_desc + "_frame_"+str(i)+".png"
                full_file = self.output_dir / basename
                fig.savefig(full_file)
                plt.close(fig)

        self.plot_figs.clear()

    def animateRDFrames(self, baseFilename: Union[str, Path], showAni=False):

        if len(self.images) >1:

            fig, ax = plt.subplots()

            extents=None
            isFirst = True
            ims = []

            cax = self._init_plot_params(fig, ax)
            dB = [-60, 10]

            for rdi in self.images:

                if isFirst:
                    extents = [np.min(rdi.cross_range), np.max(rdi.cross_range),
                               np.min(rdi.rel_range), np.max(rdi.rel_range)]
                    isFirst = False

                im = ax.imshow(20.0*np.log10(np.abs(rdi.img.T)),
                               extent=extents,
                               animated=True,
                               cmap="viridis",
                               vmin=dB[0], vmax=dB[1])

                ax.set_aspect('auto')
                fig.colorbar(im, cax=cax, orientation="vertical")
                plt.jet()

                ax.set_title("IMG Program: Center Time = " + str(rdi.time))
                ax.set_xlabel("Cross Range (m)")
                ax.set_ylabel("Relative Range (m)")

                ims.append([im])

            anikin = animation.ArtistAnimation(fig, ims, interval=1000*(1/self.period),
                                               blit=True, repeat_delay=2000)

            if baseFilename is not None:
                fullfilename = self.output_dir / baseFilename
                writergif = animation.PillowWriter(fps=60)
                anikin.save(fullfilename, writer=writergif)

            if showAni:
                plt.show()

        else:
            raise RuntimeWarning('Generate ISAR images before doinga animation ...')

    def getRangeBounds(self):

        bounds = None
        if len(self.images) > 0:
            crossRanges = np.array([img.cross_range for img in self.images])
            relRanges = np.array([img.rel_range for img in self.images])

            minCR = np.min(crossRanges)
            maxCR = np.max(crossRanges)

            minRR = np.min(relRanges)
            maxRR = np.max(relRanges)

            bounds = dotdict({"cross_range": (minCR, maxCR), "rel_range": (minRR, maxRR)})

        return bounds

    def getFirstImgTime(self):
        return self.__imgStartTimes[0]

    def addNoise(self, SNR=30):

        pk = np.amax(self.rcs, axis=1)
        pkMode, = mode(np.round(pk*10)/10)[0] # most common peak

        pulses = np.power(10, self.rcs/20) * np.exp(1j*np.pi*self.phase/180.0)
        noiseLevel = pkMode - float(SNR)
        noisePower = np.power(10, noiseLevel/10)

        noise = np.power(10, (noiseLevel/20)*np.random.randn(*pulses.shape)) + \
            1j*np.power(10, (noiseLevel/20)*np.random.randn(*pulses.shape))

        # constructive noise interference
        noisySignal = pulses + noise

        self.rcs_noisy = 20*np.log10(np.abs(noisySignal))
        self.phase_noisy = 180 * np.angle(noisySignal) / np.pi

        self.__reset_iter()

## for testing object functionality
if __name__ == "__main__":
    test_hwb = "G:/WSU/CS_7840/final_project/input_cfgs/seed/loc0_time1.hwb"

    rdi = RDI.from_hwb_file(test_hwb, False)
    rdi.doPlots = True
    rdi.generate_isar()
    rdi.animateRDFrames("loc0_time1.gif", True)

