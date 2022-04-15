from isar_db.isar_db_model import Models
from isar_db.mongo_interface import isar_db
from isar_db.isar_db_model import decode_numpy
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn import preprocessing
import collections
import tensorflow as tf
from sklearn.preprocessing import StandardScaler


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
    elif model == Models.FINS.value:
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


def normalize_data(img: np.ndarray):

    maxes = np.max(img, axis=1)
    mins = np.min(img, axis=1)

    maxim = np.max(maxes)
    mini = np.min(mins)

    #img_normalized = (img - mins[:, np.newaxis]) / (maxes[:, np.newaxis]-mins[:, np.newaxis])
    img_normalized = (img - mini) / (maxim-mini)

    return img_normalized

def pull_isar_from_db():

    mongodb = isar_db()

    query = mongodb.get_isar_training_data()

    img_size = len(decode_numpy(query[0]["img"])["array"][0]) * len(decode_numpy(query[0]["img"])["array"])
    img_sizes = (len(decode_numpy(query[0]["img"])["array"][0]), len(decode_numpy(query[0]["img"])["array"]))
    img_data = np.zeros((len(query), img_size))

    labels = np.zeros(len(query))
    #labels = []

    for i, q in enumerate(query):

        current_img = q["img"]
        current_img_data = decode_numpy(current_img)["array"]
        img_np_arr_flat = np.array(current_img_data).flatten()
        img_data[i, :] = img_np_arr_flat
        labels[i] = q["model_label"]
        #labels.append(encode_model(q["model_label"]))

    labels = labels.astype('uint8')
    min_max_scaler = preprocessing.MinMaxScaler()
    img_data_norm = min_max_scaler.fit_transform(img_data)
    #img_data_norm = normalize_data(img_data)
    img_data_2d = np.reshape(img_data_norm, (len(query), img_sizes[0], img_sizes[1]))


    labels = preprocessing.LabelEncoder().fit_transform(labels)
    counter = collections.Counter(labels)
    max_v = float(max(counter.values()))
    w_classes = {cls: round(max_v/v, 2) for cls, v in counter.items()}

    return img_data_2d, img_data_norm, labels, w_classes


def split_data(img_data, labels, split_factor = 0.2):
    x_train, x_test, y_train, y_test = train_test_split(img_data, labels,
                                                        test_size=split_factor, random_state=42, shuffle=True)

    return x_train, x_test, y_train, y_test


def pre_process(useFlat=False):
    img2d, img_flat, labels, weights = pull_isar_from_db()
    if useFlat:
        img = img_flat
    else:
        img = img2d

    x_train, x_test, y_train, y_test = split_data(img, labels, 0.2)

    return x_train, x_test, y_train, y_test, weights


if __name__ == "__main__":
    x_train, x_test, y_train, y_test, w = pre_process()