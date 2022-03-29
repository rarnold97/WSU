import numpy as np
import h5py
from typing import List, Union
import enum
from scipy.signal.windows import kaiser
from scipy.fft import fft, ifft, fftshift
from pathlib import Path

import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable

from libISAR.isar_utils import get_rcs_phase_hwb, getCpxData, findNextPowerOf2


class PROCESS_TYPE(enum.Enum):
    TIME = int(0)
    ANGLE = int(1)


class RDI:
    c = 299792458

    proc_type = PROCESS_TYPE.TIME
    period = 73.0
    periodAngle = 360
    anglePerImage = 6.03
    shiftFactor = 0.25
    thinFactor = 1.0
    numImgsOutput = 5
    angle_per_img = 0.1
    timePerImage = period / 25
    kaiser_beta = 3*np.pi
    output_dir = Path("G:/WSU/CS_7840/final_project/isar_img_files")
    savePlots = False

    def __init__(self,
                 rcs: np.ndarray = np.array([]),
                 phase: np.ndarray = np.array([]),
                 times: Union[List[float], np.ndarray] = np.array([]),
                 center_freq: float = 0.0,
                 rng_gate_spc: np.ndarray[float] = 0.0):

        self.rcs = rcs
        self.phase = phase
        self.pulse_times = times
        self.cf = center_freq
        self.rng_gate_spc = rng_gate_spc
        self.__rangeScale = rng_gate_spc[0]
        self.images = []
        self.__startTime = times[0]

        self.__isar_idx: List[int] = []
        self.__start_angle = 0.0
        self.__targetAA = np.zeros(self.rcs.shape)
        self.__pulseAngles = np.zeros(self.rcs.shape)
        self.__rangeScale:float = 0.0

        self.isar_img_files = []

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


    def __getIsarIndeces(self, img_num: int):

        # output array of indices
        indices = []

        fileNumPulses = len(self.pulse_times)
        fileStartTime = self.pulse_times[0]
        fileStopTime = self.pulse_times[-1]
        numPulsesOut = 0

        imgStartTime = 0.0
        if RDI.proc_type == PROCESS_TYPE.TIME:
            imgStartTime = self.__startTime + img_num * RDI.shiftFactor * RDI.timePerImage

        ## dont think I am going to use this feature, going to keep it unfinished for later development
        elif RDI.proc_type == PROCESS_TYPE.ANGLE:
            stopAngle = self.__start_angle + RDI.angle_per_img

        firstIndex = np.argwhere(self.pulse_times >= imgStartTime)[0]
        if firstIndex:
            idx_first_unpacked = firstIndex[0]
            indices.append(idx_first_unpacked)
        else:
            indices.append(int(0))

        if self.pulse_times[indices[0]] + RDI.timePerImage > fileStopTime:
            numPulsesOut = 0
            return

        idx_window = np.argwhere(self.pulse_times <= imgStartTime + RDI.timePerImage)[0]
        if idx_window:
            indices.append(idx_window)

        numPulsesOut = len(idx_window) + 1
        return numPulsesOut, indices


    def __preCountNumImages(self):

        fileStartTime = self.pulse_times[0]
        fileStopTime = self.pulse_times[-1]
        totalProcessTime = fileStopTime - fileStartTime

        imgNum = 0
        totalPulses = 0

        while True:
            numPulsesOut, indices = self.__getIsarIndeces(imgNum)
            if numPulsesOut == 0:
                break

            imgNum += 1
            totalPulses = totalPulses + numPulsesOut

            if self.pulse_times[indices[-1]] > self.__startTime + totalProcessTime:
                break

        return imgNum


    def __calcAngles(self, pulseIdx: Union[List[int], np.ndarray[int]]):

        if self.proc_type == PROCESS_TYPE.TIME:
            refTime = (self.pulse_times[0] + self.pulse_times[-1]) / 2
            self.__pulseAngles = 360.0 * (self.pulse_times[pulseIdx] - refTime) / self.period
        elif self.proc_type == PROCESS_TYPE.ANGLE:
            refAngle = (self.__targetAA[pulseIdx[0]] + self.__targetAA[pulseIdx[-1]])
            self.__pulseAngles = self.__targetAA[pulseIdx] - refAngle

    def __runImageProgram(self, imgNum:int, plotCount:int):

        _, pulseIdx = self.__getIsarIndeces(imgNum)
        C = getCpxData(self.rcs, self.phase, pulseIdx)
        npulses, ngates = C.shape

        w = kaiser(npulses, RDI.kaiser_beta)
        C = (C * w).T

        nfft_dopp = np.power(2, findNextPowerOf2(npulses))
        nfft_dopp = 256 if nfft_dopp < 256 else nfft_dopp

        # compute the range window
        self.__calcAngles(pulseIdx)
        delT = self.pulse_times[-1] - self.pulse_times[0]
        # get the center frequency in hz
        f_c = self.cf * 1e6
        rng_window = ngates * self.__rangeScale
        rel_range = np.linspace(-rng_window/2, rng_window/2, ngates)

        # calc doppler scales and cross range window
        doppScale = npulses / (delT*nfft_dopp)
        rangeRateScale = doppScale * RDI.c / (2.0*f_c)
        processingAngle = self.__pulseAngles[-1] - self.__pulseAngles[0]
        crossRangeScale = (rangeRateScale * delT) / (np.deg2rad(processingAngle))
        x_rng_window = crossRangeScale * nfft_dopp
        cross_range = np.linspace(-x_rng_window/2, x_rng_window/2, nfft_dopp)

        # Generate ISAR Plot
        RD = fft(C, nfft_dopp, 0)
        # shift pulses to center via fft shift
        RD = fftshift(RD, 0) / npulses

    @staticmethod
    def genIsarPlot(img:np.ndarray,
                    crossRange:np.ndarray[float],
                    relRange:np.ndarray[float],
                    plotTitle,
                    x_title:str="Cross Range",
                    y_title:str="Range",
                    isarType:str="RD",
                    output_filename: Path = None)->plt.figure:

        fig = plt.figure()
        ax = fig.add_subplots(111)
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


        ax.set_title(plotTitle)
        ax.set_xlabel(x_title)
        ax.set_ylabel(y_title)

        fig.colorbar(im, cax=cax, orientation='vertical')
        plt.jet()

        if output_filename is not None:
            fig.savefig(output_filename)
            plt.close(fig)

        return fig

    def generate_isar(self):