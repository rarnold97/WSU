import numpy as np
import numpy.matlib
from typing import List
from libISAR.rdi import RDI
from libISAR.rdi import dotdict
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable
import time
from scipy import ndimage


def init_ecp_params(rdi: RDI):

    MAX_ECP_CGS = 30

    params ={
        "numSamples": rdi.current_img.nfft,
        "procRadius": rdi.rng_gate_spc[rdi.current_idx] * rdi.ngates[rdi.current_idx] / 2.0,
        "orientTime": rdi.getFirstImgTime(),
        "coherentSum": 1,
        "defaultCGBin": 0,
        "defaultCGGate": 0,
        "cgBins": np.zeros(MAX_ECP_CGS),
        "cgGates": np.zeros(MAX_ECP_CGS),
        "rotationAngleBis": float(0)
    }

    return dotdict(params)



def do_interp(img, xnew, ynew, dphase, vectorized =False):

    # find the grid location in reference image
    ix = np.floor(xnew).astype(int)
    iy = np.floor(ynew).astype(int)

    weightx = xnew - ix
    weighty = ynew - iy

    xint1_real = (img[iy, ix+1].real - img[iy, ix].real) * weightx + img[iy, ix].real
    xint2_real = (img[iy+1, ix +1].real - img[iy + 1, ix].real)*weightx + img[iy+1, ix].real

    xint1_imag = (img[iy, ix+1].imag - img[iy, ix].imag) * weightx + img[iy, ix].imag
    xint2_imag = (img[iy+1, ix+1].imag - img[iy+1, ix].imag)*weightx + img[iy+1, ix].imag

    pic_int = ( (xint2_real - xint1_real)*weighty + xint1_real, (xint2_imag-xint1_imag)*weighty + xint1_imag )

    pic_rot_I = pic_int[0] * np.cos(dphase) - pic_int[1]*np.sin(dphase)
    pic_rot_Q = pic_int[0] * np.sin(dphase) + pic_int[1]*np.cos(dphase)

    return pic_rot_I + 1j*pic_rot_Q


def trans_rotate(rdi: RDI, ecp_params, dTheta: float):

    img = rdi.current_img
    pic_rot = 0.00001*np.ones((ecp_params.numSamples, ecp_params.numSamples)) + \
              1j*0.00001*np.ones((ecp_params.numSamples, ecp_params.numSamples))

    igate = np.arange(0, ecp_params.numSamples, 1)
    ibin = np.arange(0, ecp_params.numSamples, 1)

    yrot = 2.0 * ecp_params.procRadius * (igate/(ecp_params.numSamples - 1.0) - 0.5)
    xrot = 2.0 * ecp_params.procRadius * (ibin / (ecp_params.numSamples - 1.0) - 0.5)

    yrots, xrots = np.meshgrid(yrot, xrot, indexing='ij')
    x = xrots * np.cos(dTheta) - yrots * np.sin(dTheta)
    y = xrots * np.sin(dTheta) + yrots * np.cos(dTheta)

    xbin = (x + img.cgDopplerBin) / img.crossRangeScale + (img.img.shape[0] / int(2))
    ybin = (y + img.cgRangeBin) / img.rangeScale + (img.img.shape[1] - 1) / 2.0

    invalid_phase_idx = np.logical_or(np.logical_or(xbin<0, xbin>=img.img.shape[0]-1), np.logical_or(ybin<0, ybin>=img.img.shape[1]-1))
    valid_phase_idx = np.logical_not(invalid_phase_idx)

    xnew = xbin[valid_phase_idx]
    ynew = ybin[valid_phase_idx]
    igate_grid, ibin_grid = np.meshgrid(igate, ibin, indexing='ij')
    igate_rotate = igate_grid[valid_phase_idx]
    ibin_rotate = ibin_grid[valid_phase_idx]
    dphase = 4 * np.pi * (yrots[valid_phase_idx] - y[valid_phase_idx]) * rdi.cf * 1e6 / rdi.c

    ix = np.floor(xnew).astype(int)
    iy = np.floor(ynew).astype(int)

    weightx = xnew - np.floor(xnew)
    weighty = ynew - np.floor(ynew)

    xint1 = (img.img.T[iy, ix+1] - img.img.T[iy, ix])*weightx + img.img.T[iy, ix]
    xint2 = (img.img.T[iy+1, ix+1] - img.img.T[iy+1, ix])*weightx + img.img.T[iy+1, ix]

    I = (xint2.real - xint1.real)*weighty + xint1.real
    Q = (xint2.imag - xint1.imag)*weighty + xint1.imag

    img_data_real = I * np.cos(dphase) - Q * np.sin(dphase)
    img_data_imag = I * np.sin(dphase) + Q*np.cos(dphase)

    pic_rot[valid_phase_idx] = img_data_real + 1j*img_data_imag

    """
    for xn, yn, ig, ib, dp in zip(xnew, ynew, igate_rotate, ibin_rotate, dphase):
        pic_rot[ig, ib] = do_interp(img.img.T, xn, yn, dp)
    """
    return pic_rot


def coherent_sum(img: np.ndarray, img_rot: np.ndarray, imgNum: int):
    """
    performs a coherent sum of two complex images
    :param img: input complex image
    :param img_rot: rotated complex image
    :param imgNum: image number in the array of images
    :return:
    """
    ratio1: float = (float(imgNum) - 1) / float(imgNum)
    ratio2: float = 1.0 / float(imgNum)

    img_co_sum = ratio1*img + ratio2*img_rot
    return img_co_sum


def ecp(rdi: RDI):

    period = rdi.period
    isFirst = True

    while rdi.setNextImg():

        if isFirst:
            ecp_params = init_ecp_params(rdi)
            pic_foc_img = np.zeros((ecp_params.numSamples, ecp_params.numSamples)) + \
                          1j * np.zeros((ecp_params.numSamples, ecp_params.numSamples))
            isFirst = False

        img_data = rdi.current_img
        imgTime = img_data.time

        dtheta = 6.28318530718 * (imgTime - ecp_params.orientTime) / period

        pic_rot = trans_rotate(rdi, ecp_params, dtheta)

        pic_foc_img = coherent_sum(pic_foc_img, pic_rot, rdi.current_idx+1)

    # return the final summed image
    return pic_foc_img, rdi.getRangeBounds()


def plot_ecp(pic_foc_img:np.ndarray, bounds, title: str):

    plt.rcParams.update({'font.size': 12, 'font.weight': 'bold', 'font.family': 'Arial'})
    fig = plt.figure()
    ax = fig.add_subplot(111)
    divider = make_axes_locatable(ax)
    cax = divider.append_axes('right', size='5%', pad=0.05)

    dB = [-60, 10]

    im = ax.imshow(20.0 * np.log10(np.abs(pic_foc_img.T)),
                   cmap="Greys",
                   extent=[bounds.cross_range[0], bounds.cross_range[1], bounds.rel_range[0], bounds.rel_range[1]],
                   vmin=dB[0], vmax=dB[1])

    ax.set_aspect('auto')
    ax.set_title(title)
    ax.set_xlabel("Cross Range (m)")
    ax.set_ylabel("Relative Range (m)")

    fig.colorbar(im, cax=cax, orientation='vertical')
    plt.show()


if __name__ == "__main__":

    start_time = time.time()
    test_hwb = "G:/WSU/CS_7840/final_project/input_cfgs/seed/loc0_time1.hwb"
    rdi = RDI.from_hwb_file(test_hwb, False)
    rdi.doPlots = False
    rdi.generate_isar()

    summed_img, bounds = ecp(rdi)
    elapsed = time.time() - start_time
    print("Processing Time: ", elapsed)
    plot_ecp(summed_img, bounds, "Test coherent summed image")