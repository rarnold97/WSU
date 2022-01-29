import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from sklearn.metrics import confusion_matrix
from numpy import linalg as la
import scipy
from scipy import misc
from sklearn.preprocessing import StandardScaler
from scipy.linalg import eigh

print('imports successful!')


def get_fig_handles():
    fig = plt.figure()
    ax = fig.add_subplot(111)
    return fig, ax



def dependent_z(x, y):
    return 0.1*np.power(x, 3) + np.square(y)

def partial_derivative(func, var=0, point=[]):
    args=point[:]
    def wraps(x):
        args[var] = x
        return func(*args)

    return misc.derivative(wraps, point[var], dx=1e-6)

def steepest_descent_3d(ax, x_start=1.5, y_start=1.8, eta=0.0001, maxIteration=100000, epsilon=0.0001):

    correction = np.inf
    num_iter = 0

    tmp_z0 = dependent_z(x_start, y_start)
    z_0 = None
    x_0 = x_start
    y_0 = y_start

    while (correction > epsilon) and (num_iter < maxIteration):
        tmp_x_0 = x_0 - eta * partial_derivative(dependent_z, 0, [x_0, y_0])
        tmp_y_0 = y_0 - eta * partial_derivative(dependent_z, 1, [x_0, y_0])
        x_0 = tmp_x_0
        y_0 = tmp_y_0
        z_0 = dependent_z(x_0, y_0)
        num_iter += 1
        correction = np.abs(tmp_z0 - z_0)
        tmp_z0 = z_0

        if (num_iter) == 1:
            print("Value of X1: %s Value of Y1: %s" % (x_0, y_0))
        elif (num_iter) == 2:
            print("Value of X2: %s Value of Y2: %s" % (x_0, y_0))

        c = 'red' if not (correction > epsilon and num_iter < maxIteration) else 'blue'

    return x_0, y_0, z_0, num_iter

dzx = lambda x,y: 3*0.1*np.square(x)
dzy = lambda x,y: 2*y
fz = lambda x,y: 0.1*np.power(x, 3) + np.square(y)

def p5_gradient(x_start, y_start, eta=0.0001, maxIter=100000, epsilon=0.0001):

    wxcurr = x_start
    wycurr = y_start
    wxprev = x_start
    wyprev = y_start

    zprev = fz(x_start, y_start)
    zcurr = None
    n = 0

    for n in range(maxIter):
        wxcurr = wxprev - eta*dzx(wxprev, wyprev)
        wycurr = wyprev - eta*dzy(wxprev, wyprev)

        if n==0:
            print("Value of X1: %s Y1: %s" % (wxcurr, wycurr))
        elif n==1:
            print("Value of X2: %s Y2: %s" % (wxcurr, wycurr))

        zcurr = fz(wxcurr, wycurr)
        error = np.abs(zcurr-zprev)

        if error < epsilon:
            break

        wxprev = wxcurr
        wyprev = wycurr
        zprev = zcurr

    return wxcurr, wycurr, zcurr, n+1


def problem5():

    # make data
    x = np.arange(-2, 2+0.01, 0.01)
    y = np.arange(-2, 2+0.01, 0.01)

    X, Y = np.meshgrid(x, y)
    Z = 0.1*np.power(X, 3) + np.square(Y)

    # plot the data
    fig, ax = plt.subplots(subplot_kw={'projection': '3d'})
    surf = ax.plot_surface(X, Y, Z, antialiased=False)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_title('Steepest Gradient Descent Minimization of Surface')

    #xmin, ymin, zmin, num_iter = steepest_descent_3d(ax, epsilon=0.0001)
    xmin, ymin, zmin, num_iter = p5_gradient(1.5, 1.8, eta=0.01)

    return fig, ax, (xmin, ymin, zmin, num_iter)



def problem6(mnist):
    N = 15000
    (x_train, y_train), (x_test, y_test) = mnist.load_data()
    data = x_train[0:N, :, :]
    label = y_train[0:N]
    #flatten the data
    sample_data = data.reshape(data.shape[0], data.shape[1]*data.shape[2])
    #centered_data = sample_data - np.outer(np.mean(sample_data, axis=1), np.ones(sample_data.shape[1]))
    scaled_data = StandardScaler().fit_transform(sample_data)

    covar_matrix = scaled_data.T @ scaled_data
    values, vectors = eigh(covar_matrix)
    vectors = vectors.T

    principle_comps = (vectors @ sample_data.T).T

    print('debug')

if __name__=="__main__":
    # load the mnist dataset
    mnist = tf.keras.datasets.mnist


    '''
    #problem 5
    fig, ax, results5 = problem5()
    xmin, ymin, zmin, n_iter = results5
    #ax.scatter(xmin, ymin, zmin, color='red')
    ax.scatter(xmin, ymin, zmin, color='red')
    #show plots
    plt.show()
    '''

    # problem 6
    problem6(mnist)
