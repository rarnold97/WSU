import tensorflow as tf
from tensorflow.keras.layers import LeakyReLU
from sklearn.metrics import accuracy_score
from sklearn.metrics import classification_report
from sklearn.svm import SVC


from libISAR.rdi import dotdict
from isar_db.isar_db_model import Models
import os
from pathlib import Path
import matplotlib.pyplot as plt
from libISARML.isarml_log import get_isarml_logger

output_path = os.environ.get("ISAR_ML_ROOT")
output_path = Path(output_path)/"ml_model" if output_path is not None else Path("X:/isar_img_ml/ml_model")


logger = get_isarml_logger()


def gen_params():
    params = dotdict({
        "deep_fun": LeakyReLU(alpha=0.01),
        "out_fun": "softmax",
        "input_drop_rate": 0.1,
        "hidden_drop_rate": 0.2,
        "learning_rate": 0.0002,
        "n_nodes_hidden": 64,
        "mask_size": (3, 3),
        "nfilters": 64,
        "strides": (2, 2),
        "epochs": 100,
        "input_shape": 0
    })

    return params

def get_conv_layers(input, params):
    input_shape = input.shape[1:]

    conv = tf.keras.layers.Conv2D(params.nfilters, params.mask_size, strides=params.strides,
                                  padding='same', activation=params.deep_fun, input_shape=input_shape)(input)
    pool = tf.keras.layers.MaxPooling2D()(conv)

    conv = tf.keras.layers.Conv2D(int(params.nfilters/2), params.mask_size, strides=params.strides,
                                  padding='same', activation=params.deep_fun)(pool)
    pool = tf.keras.layers.MaxPooling2D()(conv)

    return pool


def build_SVM_model():
    svc = SVC(kernel='poly', degree=3, gamma='auto')
    return svc

def fit_SVM(svc, X_train, y_train, X_test, Y_test):

    svc.fit(X_train, y_train)
    y2 = svc.predict(X_test)

    print("Accuracy on image dataset is: ", accuracy_score(Y_test, y2))
    print("Accuracy Report: ", classification_report(Y_test, y2))
    logger.info("Accuracy on image dataset is: " + str(accuracy_score(Y_test, y2)))
    logger.info("Accuracy Report: " + classification_report(Y_test, y2))


def build_DCNN_model(params: dotdict):


    # create an input layer
    input_layer = tf.keras.layers.Input(shape=params.input_shape)

    ## create convolutional layers, using 2 layers in this model
    conv2d_layers = get_conv_layers(input_layer, params)

    # create feature vector layer
    fv = tf.keras.layers.Flatten()(conv2d_layers)

    # create the dense layers and work on the feature vector

    dense = tf.keras.layers.Dense(params.n_nodes_hidden, activation=params.deep_fun)(fv)
    dense = tf.keras.layers.Dropout(params.hidden_drop_rate)(dense)

    dense = tf.keras.layers.Dense(params.n_nodes_hidden, activation=params.deep_fun)(dense)
    dense = tf.keras.layers.Dropout(params.hidden_drop_rate)(dense)

    # output layer
    output_layer = tf.keras.layers.Dense(units=len(Models), activation=params.out_fun)(dense)

    model = tf.keras.Model(inputs=input_layer, outputs=output_layer)


    opt = tf.keras.optimizers.Adam(lr=params.learning_rate, beta_1=0.9)
    #opt = tf.keras.optimizers.SGD(learning_rate=params.learning_rate, momentum=0.9)
    model.compile(loss=tf.losses.SparseCategoricalCrossentropy(from_logits=True), optimizer=opt, metrics=['accuracy'])

    # save a summary of the model
    model_summary_fname = output_path / "model_report.txt"

    with open(model_summary_fname, 'w') as fh:
        model.summary(print_fn=lambda x: fh.write(x + '\n'))

    return model


def plot_history(history):
    fig1 = plt.figure()
    ax1 = fig1.add_subplot(111)

    ax1.plot(history['accuracy'], label='train')
    ax1.plot(history['val_accuracy'], label='test')
    ax1.set_title('Model Accuracy')
    ax1.set_xlabel('epoch')
    ax1.set_ylabel('accuracy')
    ax1.legend(loc='upper left')


    fig2 = plt.figure()
    ax2 = fig2.add_subplot(111)

    ax2.plot(history['loss'], label='train')
    ax2.plot(history['val_loss'], label='test')
    ax2.set_title('Model Loss')
    ax2.set_xlabel('epoch')
    ax2.set_ylabel('loss')
    ax2.legend(loc='upper left')

    plt.show()

def train(model, X, y, X_validate, y_validate, n_epochs=100):
    """
    Train the DCNN and export the best model along with a model summary
    :param model: keras tensorflow model
    :param X: training data
    :param y: training labels
    :param X_validate: validation data
    :param y_validate: validation labels
    :param w_classes: weights of the classes as they appear in the data
    :return:
    """

    # stop the model early if possible
    early_stop = tf.keras.callbacks.EarlyStopping(
        monitor='val_loss',
        mode='min',
        verbose=1,
        patience=10
    )

    model_output_fp = output_path / "isar_dcnn_model.h5"

    model_ckpt = tf.keras.callbacks.ModelCheckpoint(
        filepath=model_output_fp,
        monitor='val_loss',
        verbose=1,
        save_best_only=True
    )

    hist = model.fit(
        x = X,
        y = y,
        batch_size=64,
        epochs = n_epochs,
        validation_data = (X_validate, y_validate),
        callbacks=[early_stop, model_ckpt]
    )

    return hist


def create_summary(history):

    best_val_loss = min(history['val_loss'])
    best_val_loss_idx = history['val_loss'].index(best_val_loss)
    best_val_acc = history['val_accuracy'][best_val_loss_idx]
    best_loss = history['loss'][best_val_loss_idx]
    best_acc = history['accuracy'][best_val_loss_idx]

    output_summary = dotdict({
        "best_val_loss": best_val_loss,
        "best_val_loss_idx": best_val_loss_idx,
        "best_val_acc": best_val_acc,
        "best_loss": best_loss,
        "best_acc": best_acc
    })

    model_output_fp = output_path / "isar_dcnn_model.h5"

    logger.info(f'Best Loss: {best_loss:.4f}, Best val accuracy: {best_val_acc*100:.2f}%')
    logger.info(f'Best val loss: {best_val_loss:.4f}, Best val accuracy: {best_val_acc*100:.2f}%')
    logger.info(f'Best Model saved to {model_output_fp}')

    logger.info('_____ Model History _____')
    for k, val in history.items():
        logger.info(f'{k} - {val}')

    plot_history(history)

    return output_summary