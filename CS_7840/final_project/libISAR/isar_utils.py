import h5py
import enum
import numpy as np
import cmath
from typing import List


class POLAR(enum.Enum):
    PP = int(0)
    OP = int(1)


def rasterize_gates(sig_arr: np.ndarray,
                    offsets: np.ndarray,
                    offset_lens: np.ndarray,
                    n_obs: int):

    n_cols = len(sig_arr) / n_obs
    rastered = np.zeros((n_obs, n_cols))

    for i, offset in enumerate(offsets):
        length = offset_lens[i]
        rastered[i, :] = sig_arr[offset:offset + length]

    return rastered


def get_rcs_phase_hwb(f5: h5py.File, polar=POLAR.PP):

    # get some of the necessary metadata
    n_obs = f5['file_header']['n_obs']

    if polar == POLAR.PP:
        rcs = f5['principal_polarization_rcs']
        phase = f5['principal_polarization_phase']
        offsets = f5['principal_offsets']['offset']
        offset_lens = f5['principal_offsets']['len']
    elif polar == POLAR.OP:
        rcs = f5['orthogonal_polarization_rcs']
        phase = f5['orthogonal_polarization_phase']
        offsets = f5['orthogonal_offsets']['offset']
        offset_lens = f5['principal_offsets']['len']
    else:
        raise ValueError('Enter a valid polarization ...')

    rcs_2d = rasterize_gates(rcs, offsets, offset_lens, n_obs)
    phase_2d = rasterize_gates(phase, offsets, offset_lens, n_obs)

    return rcs_2d, phase_2d



def getCpxData(rcs, phase, idx):

    A = np.power(10, 0.05 * rcs[idx, :])
    I = A*np.cos(-1.0*np.deg2rad(phase[idx, :]))
    Q = A*np.sin(-1.0*np.deg2rad(phase[idx, :]))
    return I + 1j*Q


def findNextPowerOf2(n):
    # decrement `n` (to handle cases when `n` itself
    # is a power of 2)
    n = n - 1

    # do till only one bit is left
    while n & n - 1:
        n = n & n - 1  # unset rightmost bit

    # `n` is now a power of two (less than `n`)
    # return next power of 2
    return n << 1

