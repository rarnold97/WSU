from libISARML.PreProc import pre_process
from libISARML.BuildModel import gen_params, build_DCNN_model, train, create_summary, build_SVM_model, fit_SVM
import logging
from pathlib import Path
import os
import json

from libISARML.isarml_log import get_isarml_logger
logger = get_isarml_logger()

output_path = os.environ.get("ISAR_ML_ROOT")
output_path = Path(output_path) if output_path is not None else Path("X:/isar_img_ml")

hist_path = output_path / "ml_model" / "history.json"


def export_hist(hist):
    history_dict = hist.history
    json.dump(history_dict, open(hist_path, 'w'))

def svm_model():
    logger.info("Fitting SVM Model")
    print("Fitting SVM Model")

    x_train, x_test, y_train, y_test, w_classes = pre_process(useFlat=True)
    svc = build_SVM_model()
    fit_SVM(svc, x_train, y_train, x_test, y_test)

    logger.info("SVM Model Complete")


def train_ml_model(load_hist=False):

    params = gen_params()

    # set the desired number of epochs for fitting the model
    params.epochs = 10

    params.learning_rate = 0.001
    params.strides = (1, 1)
    params.nfilters = 64
    params.n_nodes_hidden = 64

    x_train, x_test, y_train, y_test, w_classes = pre_process(useFlat=False)

    print('Preprocessing and Querying of input data complete ...')
    logger.info('Preprocessing and Querying of input data complete ...')

    params.input_shape = x_train.shape[1:] + (1,)

    if not load_hist:
        model = build_DCNN_model(params)

        hist = train(model, x_train, y_train, x_test, y_test, params.epochs)

        export_hist(hist)

        history = hist.history

    else:
        history = json.load(open(hist_path, 'r'))

    create_summary(history)

    logger.info('Model built and fit successfully !')
    print('Model built and fit successfully !')


if __name__ == "__main__":
    train_ml_model(load_hist=False)