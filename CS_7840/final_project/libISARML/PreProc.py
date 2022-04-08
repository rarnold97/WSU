from isar_db.isar_db_model import Models
import numpy as np


def encode_model(model: int):

    coded = np.zeros(len(Models))
    # Options
    # CYLINDER = 0
    # CONIC = 1
    # CONIC_CAPPED = 2
    # CONE_CYLINDER = 3
    # DBL_CONIC = 4
    # ROCKET_BODY = 5
    # FINS = 6
    # PBV = 7

    if model == Models.CYLINDER.value:
        coded[0] = 1
    elif model == Models.CONIC.value:
        coded[1] = 1
    elif model == Models.CONIC_CAPPED.value:
        coded[2] = 1
    elif model == Models.CONE_CYLINDER.value:
        coded[3] = 1
    elif model == Models.DBL_CONIC.value:
        coded[4] = 1
    elif model == Models.ROCKET_BODY.value:
        coded[5] = 1
    elif model == Models.Fins.value:
        coded[6] = 1
    elif model == Models.PBV.value:
        coded[7] = 1
    else:
        raise SyntaxError('Enter a valid model integer ...')

    return coded


def decode_model(coded: np.ndarray):

    if len(coded) != len(Models):
        raise ValueError('Invalid length of hot encoded array ...')

    max_idx = np.argmax(coded)

    res: Models = Models.CYLINDER

    if max_idx == 0:
        res = Models.CYLINDER
    elif max_idx == 1:
        res = Models.CONIC
    elif max_idx == 2:
        res = Models.CONIC_CAPPED
    elif max_idx == 3:
        res = Models.CONE_CYLINDER
    elif max_idx == 4:
        res = Models.DBL_CONIC
    elif max_idx == 5:
        res = Models.ROCKET_BODY
    elif max_idx == 6:
        res = Models.FINS
    elif max_idx == 7:
        res = Models.PBV

    return res
