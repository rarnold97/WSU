import enum
import numpy as np
from pathlib import Path
import json
from json import JSONEncoder
import base64
import os
from bson.objectid import ObjectId
from typing import Union


class NumpyArrayEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, np.ndarray):
            return obj.tolist()
        return JSONEncoder.default(self, obj)


def json_numpy_obj_hook(dct):
    """
    Decodes a previously encoded numpy ndarray
    with proper shape and dtype
    :param dct: (dict) json encoded ndarray
    :return: (ndarray) if input was an encoded ndarray
    """
    if isinstance(dct, dict) and '__ndarray__' in dct:
        data = base64.b64decode(dct['__ndarray__'])
        return np.frombuffer(data, dct['dtype']).reshape(dct['shape'])
    return dct


# Overload dump/load to default use this behavior.
def dumps(*args, **kwargs):
    kwargs.setdefault('cls', NumpyArrayEncoder)
    return json.dumps(*args, **kwargs)


def loads(*args, **kwargs):
    kwargs.setdefault('object_hook', json_numpy_obj_hook)
    return json.loads(*args, **kwargs)


def dump(*args, **kwargs):
    kwargs.setdefault('cls', NumpyArrayEncoder)
    return json.dump(*args, **kwargs)


def load(*args, **kwargs):
    kwargs.setdefault('object_hook', json_numpy_obj_hook)
    return json.load(*args, **kwargs)


def encode_numpy(arr: np.ndarray):
    return json.dumps({"array": arr}, cls=NumpyArrayEncoder)


def decode_numpy(record):
    return loads(record)


def serialize_dict(d: dict):
    for key, value in d.items():
        if type(value) is Path:
            d[key] = str(value)
        elif type(value) is np.ndarray:
            d[key] = encode_numpy(value)

    return d


class Models(enum.Enum):
    CYLINDER = 0
    CONIC = 1
    CONIC_CAPPED = 2
    CONE_CYLINDER = 3
    DBL_CONIC = 4
    ROCKET_BODY = 5
    FINS = 6
    PBV = 7


class SignatureRecord:
    data_root: str = str("X:/isar_img_ml/signature_files")

    def __init__(self):
        # might be redundant, but want to ensure this gets serialized for use as Mongo document
        self.data_root = SignatureRecord.data_root

        self.hwb_filename: str = os.path.join(self.data_root, "loc0_time1.hwb")
        self.model_file: str = ""
        self.model_type: int = Models.CYLINDER.value
        self.motion_filename: str = ""
        self.kappa: float = 0
        self.theta: float = 0
        self.spin_period: float = 0
        self.prec_period = 10.0  # seconds
        self.simxml: str = ""

        #self.doc_id: int = 0

    def get_dict(self) -> dict:
        data = vars(self)
        return serialize_dict(data)


class CompImageRecord:

    def __init__(self, image_data: np.ndarray, pid: Union[str, int] = '9999'):
        if len(image_data.shape) != 2:
            raise ValueError("Image must be specifically 2D ...")

        self.phi_i: float = 0
        self.theta_i: float = 0
        self.lambda_i: float = 0

        self.SNR: float = 0

        if np.iscomplex(image_data).any():
            self.img = 20 * np.log10(np.abs(image_data.T))
        else:
            self.img: np.ndarray = image_data

        self.kappa_label: float = 0
        self.theta_label: float = 0
        # default as cylinder
        self.model_label: int = 0

        self.crossRangeStart: float = 0
        self.crossRangeStop: float = 0
        self.relRangeStart: float = 0
        self.relRangeStop: float = 0

        self.parent_doc_id: ObjectId = ObjectId(pid)

    def get_dict(self) -> dict:
        data = vars(self)
        return serialize_dict(data)

    def setParId(self, id: str):
        self.parent_doc_id = ObjectId(id)


if __name__ == "__main__":
    test = np.zeros((3,3))
    js = encode_numpy(test)
    print(js)