import enum
import numpy as np
from pathlib import Path
import json
import base64


class NumpyEncoder(json.JSONEncoder):
    def default(self, obj):
        """
        if input object is a ndarray it will be converted into a dict holding dtype, shape and the data base64 encoded
        """
        if isinstance(obj, np.ndarray):
            data_b64 = base64.b64encode(obj.data)
            return dict(__ndarray__=data_b64,
                        dtype=str(obj.dtype),
                        shape=obj.shape)
        # Let the base class default method raise the TypeError
        return json.JSONEncoder(self, obj)


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
    kwargs.setdefault('cls', NumpyEncoder)
    return json.dumps(*args, **kwargs)


def loads(*args, **kwargs):
    kwargs.setdefault('object_hook', json_numpy_obj_hook)
    return json.loads(*args, **kwargs)


def dump(*args, **kwargs):
    kwargs.setdefault('cls', NumpyEncoder)
    return json.dump(*args, **kwargs)


def load(*args, **kwargs):
    kwargs.setdefault('object_hook', json_numpy_obj_hook)
    return json.load(*args, **kwargs)


def encode_numpy(arr: np.ndarray):
    return dumps(arr)


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
    ROCKET_BODY = 2
    FAIRING = 3
    PBV = 4


class SignatureRecord:
    data_root: Path = Path("G:/WSU/CS_7840/final_project/img_database")

    def __init__(self):
        # might be redundant, but want to ensure this gets serialized for use as Mongo document
        self.data_root = SignatureRecord.data_root

        self.hwb_filename: Path = Path(SignatureRecord.data_root)
        self.model_file: Path = Path('')
        self.model_type: int = Models.CYLINDER.value
        self.SNR: float = 30.0
        self.motion_filename: Path = Path(SignatureRecord.data_root)
        self.kappa: float = 0
        self.theta: float = 0
        self.spin_period: float = 0
        self.prec_period = 10.0  # seconds

        self.doc_id: int = 0

    def get_dict(self) -> dict:
        data = vars(self)
        return serialize_dict(data)


class CompImageRecord:

    def __init__(self, image_data: np.ndarray, pid: int = 9999):
        if len(image_data.shape) != 2:
            raise ValueError("Image must be specifically 2D ...")

        self.phi_i: float = 0
        self.theta_i: float = 0
        self.lambda_i: float = 0

        self.image_data: np.ndarray = image_data
        self.kappa_label: float = 0
        self.theta_label: float = 0

        self.parent_doc_id: int = pid

    def get_dict(self) -> dict:
        data = vars(self)
        return serialize_dict(data)
