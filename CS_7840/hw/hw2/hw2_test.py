import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from typing import Union, Callable, List
import random
from itertools import compress
from sklearn.model_selection import train_test_split
from sklearn import datasets
from sklearn.preprocessing import StandardScaler


def load_iris(split: float = 0.2):
    iris = datasets.load_iris()
    x = iris.data
    y = iris.target

    x_train, x_test, y_train, y_test = train_test_split(x,y, test_size=split)
    return x_train, x_test, y_train, y_test


def softmax_deriv(x):
    s = np.exp(x-np.max(x)) / np.sum(np.exp(x-np.max(x)))
    si_sj = -s * s.reshape((len(x), 1))
    s_der = np.diag(s) + si_sj
    return s_der


class ActivationFunction:
    sigmoid = lambda x: 1 / (1 + np.exp(-x))
    relu = lambda x: x * (x > 0)
    relu_leaky = lambda x: x * (x >= 0) + 0.01 * x * (x < 0)
    tanh = lambda x: np.tanh(x)
    softmax = lambda x: np.exp(x-np.max(x)) / np.sum(np.exp(x-np.max(x)))

    sigmoid_deriv = lambda x: x * (1 - x)
    relu_deriv = lambda x: float(x >= 0)
    relu_leaky_deriv = lambda x: 0.01 * (x < 0) + (x >= 0)
    tanh_deriv = lambda x: 1 - np.square(ActivationFunction.tanh(x))
    softmax_deriv = lambda x: softmax_deriv(x)

    def __init__self(self, x=None):
        self.x = x


class dotdict(dict):
    """dot.notation access to dictionary attributes"""
    __getattr__ = dict.get
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__delitem__


def has_length(obj):
    return isinstance(obj, list) or isinstance(obj, tuple) or isinstance(obj, np.ndarray)


def get_default_params():
    params = {
        "learning_rate": 0.05,
        "act_fun": ActivationFunction.relu_leaky,
        "act_fun_deriv": ActivationFunction.relu_leaky_deriv,
        "depth": 2,
        "input_drop_rate": 0.2,
        "hidden_layer_drop_rate": 0.05,
        "n_elements_input": 4,
        # should be the number of components or elements in the input layer (i.e., pixel, component, etc.)
        "n_neurons_hidden": 5,
        "n_neurons_output": 3,  # this should be the number of classifieers in classification network
        "max_epochs": 20,
        "hiddenValueBias": -1,
        "outputValueBias": -1,
        "momentum": 1.0
    }

    return dotdict(params)


class MultiLayerPerceptron:

    def __init__(self,
                 params_in=None
                 ):

        params = get_default_params() if params_in is None else params_in

        self.learning_rate = params.learning_rate
        self.depth = params.depth
        self.momentum = params.momentum

        self.act_fun = params.act_fun
        self.act_fun_deriv = params.act_fun_deriv

        self.input_drop_rate = params.input_drop_rate
        self.hidden_layer_drop_rate = params.hidden_layer_drop_rate

        self.n_elements_input = params.n_elements_input
        self.n_neurons_hidden = params.n_neurons_hidden

        # this should equal the number of distinct classifiers
        self.n_neurons_output = params.n_neurons_output

        # this could be changed for non classifier networks
        self.n_classes = self.n_neurons_output

        self.max_epochs = params.max_epochs

        self.hiddenValueBias = params.hiddenValueBias
        self.outputValueBias = params.outputValueBias

        # error checking
        n_funs = 1 if not has_length(params.act_fun) else len(params.act_fun)
        n_derivs = 1 if not has_length(params.act_fun_deriv) else len(params.act_fun_deriv)

        if n_funs != n_derivs:
            raise ValueError('Pass in an equal number of derivatives to correspond to each activation function!')

        # SET ACTIVATION FUNCTIONS
        ################################################################
        if n_funs != self.depth or n_funs == 1:
            if n_funs == 1:
                self.act_fun = [params.act_fun for _ in range(self.depth)]
                self.act_fun_deriv = [params.act_fun_deriv for _ in range(self.depth)]
            else:
                raise ValueError('Enter activation functions for each layer if not using a function uniformly')
        else:
            self.act_fun = params.act_fun
            self.act_fun_deriv = params.act_fun_deriv

        ################################################################

        # SET THE WEIGHTS
        ################################################################
        self.WEIGHTS_HIDDEN = []

        for k in range(self.depth-1):
            if k == 0:
                # dealing with the input signal here
                self.WEIGHTS_HIDDEN.append(self.init_starting_weights(self.n_neurons_hidden, self.n_elements_input))
            else:  # connects to the input layer
                self.WEIGHTS_HIDDEN.append(self.init_starting_weights(self.n_neurons_hidden, self.n_neurons_hidden))


        self.WEIGHTS_OUTPUT = self.init_starting_weights(self.n_neurons_output, self.n_neurons_hidden)
        ################################################################

        # SET THE BIASES
        ################################################################
        self.BIAS_hidden = []
        for k in range(self.depth-1):
            self.BIAS_hidden.append(np.array([self.hiddenValueBias for i in range(self.n_neurons_hidden)]))

        self.BIAS_output = np.array([self.outputValueBias for i in range(self.n_neurons_output)])
        ################################################################

        # pre initialize the layer outputs
        self.OUTPUT_HIDDEN = [np.zeros(self.n_neurons_hidden) for _ in range(self.depth-1)]
        self.OUTPUT_OUTPUT_LAYER = None

        # error related terms
        self.total_error = float(0)

        # output summary stuff
        self.error_array = []
        self.epoch_array = []

        self.W_Hidden_collection = []
        self.W_outputs = []

        self.hidden_mask = [np.ones(self.n_neurons_hidden) > 0 for _ in range(self.depth-1)]
        self.input_mask = np.ones(self.n_elements_input) > 0

    def _getInputLayerDropMask(self):

        mask = np.random.binomial(1, 1.0-self.input_drop_rate, self.n_elements_input).astype(int)
        return mask > 0

    def _getHiddenLayerDropMask(self):

        mask = np.random.binomial(1, 1.0-self.hidden_layer_drop_rate, self.n_neurons_hidden).astype(int)
        return mask > 0

    def init_starting_weights(self, n_outputs, n_inputs):
        return [[2 * random.random() - 1 for i in range(n_outputs)] for j in range(n_inputs)]

    def _get_petals_desired(self, y):

        output = np.zeros(self.n_classes)

        if y == 0:
            output = np.array([1, 0, 0])
        elif y == 1:
            output = np.array([0, 1, 0])
        elif y == 2:
            output = np.array([0, 0, 1])

        return output

    def _encode_output_layer(self):
        output_layer = self.OUTPUT_OUTPUT_LAYER
        encoded = np.zeros(3)
        indeces = np.where(output_layer == np.max(output_layer))[0]
        index = indeces[0]
        encoded[index] = 1
        return encoded

    def show_err_graphic(self, v_erro, v_epoca):
        plt.figure(figsize=(9, 4))
        plt.plot(v_epoca, v_erro, "m-", marker=11)
        plt.xlabel("Number of Epochs")
        plt.ylabel("Squared Error (MSE) ")
        plt.title("Error Minimization")
        plt.show()

    def _prop_forward(self, x_element):

        # this is kind of hard coded for classifier network, but that will suffice for the homework
        self.output = np.zeros(self.n_neurons_output)

        # weights applied to the input layer are the first element of the hidden weights

        # drop the input layer components as deemed neccessary
        input_dropped = list(compress(x_element, self.input_mask))
        weights_input_dropped = list(compress(self.WEIGHTS_HIDDEN[0], self.input_mask))

        # we also need to drop the first hidden layer in addition to any input layer drops
        weights_dropped = [list(compress(weight_set, self.hidden_mask[0])) for weight_set in weights_input_dropped]
        bias_dropped = np.array(list(compress(self.BIAS_hidden[0], self.hidden_mask[0])))

        induced_field_L1 = np.dot(input_dropped, weights_dropped) + bias_dropped.T

        self.OUTPUT_HIDDEN[0] = self.act_fun[0](induced_field_L1)

        # now we iterate through all the hidden layers
        induced_field_hidden: np.ndarray = None
        tmp_inputs = self.OUTPUT_HIDDEN[0]

        # only drop the inputs once to account for the hidden layer mask
        # handle all the dense neurons
        for k in range(1, self.depth - 1):
            # now the number of inputs have possibly changed, adjust current layer weights for that
            weights_adjusted = list(compress(self.WEIGHTS_HIDDEN[k], self.hidden_mask[k-1]))
            # adjust weights and bias for the loss of current hidden layer node in the output dimension
            dropped_weights = [list(compress(weight, self.hidden_mask[k])) for weight in weights_adjusted]
            dropped_bias = np.array(list(compress(self.BIAS_hidden[k], self.hidden_mask[k])))

            induced_field_hidden = np.dot(tmp_inputs, dropped_weights) + dropped_bias.T
            self.OUTPUT_HIDDEN[k] = self.act_fun[1](induced_field_hidden)
            tmp_inputs = self.OUTPUT_HIDDEN[k]

        # now we do computation on the output layer
        # adjust for loss of input due to the previous layer drop
        dropped_output_weights = list(compress(self.WEIGHTS_OUTPUT, self.hidden_mask[-1]))
        # we have no output layer drop rate, so no need for adjustment in the output dimension

        output_layer_field = np.dot(tmp_inputs, dropped_output_weights) + self.BIAS_output.T
        self.OUTPUT_OUTPUT_LAYER = self.act_fun[-1](output_layer_field)

    def _calc_error_energy(self):

        square_error = 0

        #encoded_outputs = self._encode_output_layer()
        output_layer = self.OUTPUT_OUTPUT_LAYER

        for i in range(self.n_neurons_output):
            erro = np.square(self.output[i] - output_layer[i])
            #erro = np.square(self.output[i] - encoded_outputs[i])
            square_error = (square_error + (0.5 * erro))

        return square_error

    def Backpropagation(self, x):

        DELTA_output = []

        # stage 1 - Error: Output layer
        ERROR_output = self.output - self.OUTPUT_OUTPUT_LAYER
        if not (self.act_fun[-1] == ActivationFunction.softmax):
            DELTA_output = ((-1) * (ERROR_output) * self.act_fun_deriv[-1](self.OUTPUT_OUTPUT_LAYER))
        else:
            DELTA_output = -1 * self.act_fun_deriv[-1](self.OUTPUT_OUTPUT_LAYER) @ ERROR_output


        arrayStore = []

        # Stage 2 - update the weights for the layers
        current_weights = list(compress(self.WEIGHTS_OUTPUT, self.hidden_mask[-1]))
        input_index = np.arange(len(self.hidden_mask[-1]))
        input_index = list(compress(input_index, self.hidden_mask[-1]))

        for i in range(len(current_weights)):
            idx_i = input_index[i]
            for j in range(self.n_neurons_output):
                if not (self.act_fun[-1] == ActivationFunction.softmax):
                    self.WEIGHTS_OUTPUT[idx_i][j] = self.momentum * current_weights[i][j] - (
                                self.learning_rate * (DELTA_output[j] * self.OUTPUT_HIDDEN[-1][i]))
                    self.BIAS_output[j] -= (self.learning_rate * DELTA_output[j])
                else:
                    self.WEIGHTS_OUTPUT[idx_i][j] = self.momentum * current_weights[i][j] - (
                                self.learning_rate * (DELTA_output[j] @ np.array(self.OUTPUT_HIDDEN[-1][i])).T)
                    self.BIAS_output[j] = 0.0

        # the k index here represents the hidden layer number
        delta_prev = DELTA_output
        weights_prev = current_weights
        delta_hidden = np.matmul(weights_prev, delta_prev) * self.act_fun_deriv[-1](self.OUTPUT_HIDDEN[-1])
        # update the hidden layers

        for k in range(self.depth - 2, 0, -1):

            current_weights = list(compress(self.WEIGHTS_HIDDEN[k], self.hidden_mask[k-1]))
            n_in = len(current_weights)
            current_weights = [list(compress(weight, self.hidden_mask[k])) for weight in current_weights]
            n_out = len(current_weights[0])

            input_index = np.arange(len(self.hidden_mask[k-1]))
            input_index = list(compress(input_index, self.hidden_mask[k-1]))

            output_index = np.arange(len(self.hidden_mask[k]))
            output_index = list(compress(output_index, self.hidden_mask[k]))

            for i in range(n_in):
                idx_i = input_index[i]# what comes in (left->right)
                for j in range(n_out):  # what comes out  (left->right)
                    idx_j = output_index[j]

                    self.WEIGHTS_HIDDEN[k][idx_i][idx_j] = self.momentum * current_weights[i][j] - (
                                self.learning_rate * (delta_hidden[j] * self.OUTPUT_HIDDEN[k - 1][i]))
                    self.BIAS_hidden[k][idx_j] -= (self.learning_rate * delta_hidden[j])

            weights_prev = current_weights
            delta_hidden = np.matmul(weights_prev, delta_hidden) * self.act_fun_deriv[k](self.OUTPUT_HIDDEN[k-1])

        # update the input layer in the first hidden layer
        # delta_hidden = np.matmul(self.WEIGHTS_HIDDEN[0], delta_hidden) * self.act_fun_deriv[0](self.OUTPUT_HIDDEN[0])

        current_weights = list(compress(self.WEIGHTS_HIDDEN[0], self.input_mask))
        n_in = len(current_weights)
        current_weights = [list(compress(weights, self.hidden_mask[0])) for weights in current_weights]
        n_out = len(current_weights[0])

        input_index = np.arange(len(self.input_mask))
        input_index = list(compress(input_index, self.input_mask))

        output_index = np.arange(len(self.hidden_mask[0]))
        output_index = list(compress(output_index, self.hidden_mask[0]))

        for i in range(n_in): # number of input elements
            for j in range(n_out): # number of outputs in first hidden layer
                idx_i = input_index[i]
                idx_j = output_index[j]
                self.WEIGHTS_HIDDEN[0][idx_i][idx_j] = self.momentum * current_weights[i][j] - (
                            self.learning_rate * (delta_hidden[j] * x[i]))
                self.BIAS_hidden[0][idx_j] -= (self.learning_rate * delta_hidden[j])

    def fit(self, X, y):
        n = len(X)
        self.error_array.clear()
        self.epoch_array.clear()

        self.W_Hidden_collection.clear()
        self.W_outputs.clear()

        self.input_mask = self._getInputLayerDropMask()
        self.hidden_mask = [self._getHiddenLayerDropMask() for i in range(self.depth - 1)]

        for epoch in range(self.max_epochs):
            total_error = 0

            # update the masks upon each epoch to make the drop truly stochastic
            #self.input_mask = self._getInputLayerDropMask()
            #self.hidden_mask = [self._getHiddenLayerDropMask() for i in range(self.depth - 1)]

            for idx, inputs in enumerate(X):
                self._prop_forward(inputs)
                self.output = self._get_petals_desired(y[idx])
                total_error += self._calc_error_energy()

                # update the weights via back propagation
                self.Backpropagation(inputs)

            total_error = (total_error / n)

            if ((epoch+1) % 10 == 0) or epoch < 10:
                print("Epoch: ", epoch+1, "- Total Error: ", total_error)
                self.error_array.append(total_error)
                self.epoch_array.append(epoch+1)

            self.W_Hidden_collection.append(self.WEIGHTS_HIDDEN)
            self.W_outputs.append(self.WEIGHTS_OUTPUT)

        self.show_err_graphic(self.error_array, self.epoch_array)
        self.plot_summary()

    def plot_summary(self):

        for k in range(self.depth - 1):
            plt.plot(self.W_Hidden_collection[k][0])
            plt.title("Weights at from training at hidden layer " + str(k + 1))
            plt.ylabel("Value Weight")
            plt.legend(["neruon " + str(i + 1) for i in range(self.n_neurons_hidden)])
            plt.show()

        plt.plot(self.W_outputs[0])
        plt.title("Weights Output Layer from training")
        plt.ylabel("Value Weight")
        plt.legend(["neruon " + str(i + 1) for i in range(self.n_neurons_output)])
        plt.show()

    def score_iris(self, predictions, y):
        array_score = []

        for i in range(len(predictions)):
            if predictions[i] == 0:
                array_score.append([i, 'Iris-setosa', predictions[i], y[i]])
            elif predictions[i] == 1:
                array_score.append([i, 'Iris-versicolour', predictions[i], y[i]])
            elif predictions[i] == 2:
                array_score.append([i, 'Iris-virginica', predictions[i], y[i]])
        return array_score

    def predict(self, X, y):
        'Returns the predictions for all the elements in the set X'
        my_predictions = []

        'Forward Propagation'
        input_signal = X
        forward = None
        for weights, bias in zip(self.WEIGHTS_HIDDEN, self.BIAS_hidden):
            forward = np.matmul(input_signal, weights) + bias
            input_signal = forward

        forward = np.matmul(input_signal, self.WEIGHTS_OUTPUT) + self.BIAS_output

        for i in range(forward.shape[0]):
            index = np.where(forward[i,:]==np.max(forward[i,:]))[0]
            predict = index[0]
            my_predictions.append(predict)

        array_score = self.score_iris(my_predictions, y)

        dataframe = pd.DataFrame(array_score, columns=['_id', 'class', 'output', 'desired_output'])

        return my_predictions, dataframe


if __name__ == "__main__":

    x_train, x_test, y_train, y_test = load_iris(split=0.2)

    params = get_default_params()

    params.input_drop_rate = 0.2
    #params.act_fun = [ActivationFunction.relu_leaky, ActivationFunction.relu_leaky, ActivationFunction.relu_leaky, ActivationFunction.sigmoid]
    #params.act_fun_deriv = [ActivationFunction.relu_leaky_deriv, ActivationFunction.relu_leaky_deriv,ActivationFunction.relu_leaky_deriv, ActivationFunction.sigmoid_deriv]
    params.depth = 4
    params.act_fun = [ActivationFunction.sigmoid] * 3
    params.act_fun_deriv = [ActivationFunction.sigmoid_deriv] * 3

    params.act_fun.append(ActivationFunction.sigmoid)
    params.act_fun_deriv.append(ActivationFunction.sigmoid_deriv)
    #params.act_fun.append(ActivationFunction.softmax)
    #params.act_fun_deriv.append(ActivationFunction.softmax_deriv)

    params.learning_rate = 0.005
    params.n_neurons_hidden = 5

    params.max_epochs = 500

    MLP = MultiLayerPerceptron(params)

    # scale data for better convergence
    scaled_x_train = StandardScaler().fit_transform(x_train)
    scaled_x_test = StandardScaler().fit_transform(x_test)

    MLP.fit(scaled_x_train, y_train)
    predictions, df = MLP.predict(scaled_x_test, y_test)
    print('Problem Compeleted Successfully ...')
