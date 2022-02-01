# imports

import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from sklearn.metrics import confusion_matrix
from numpy import linalg as la
import scipy

from sklearn.preprocessing import StandardScaler
from scipy.linalg import eigh
from scipy.spatial.distance import cdist


from sklearn.cluster import KMeans

def get_each_digit(image_data, labels):
    unique_digit_sets = []
    # loop through all the digits 0-9
    for dig in range(9 + 1):
        # find the indexes where the digits equal 0-9
        indexes = np.where(labels == dig)[0]
        # randomly select one of the digits that are the same technically
        idx = np.random.choice(indexes, 1, replace=False)
        # append the digit images to the list that will be of length 10
        unique_digit_sets.append(np.array(image_data[idx, :]))

    # stack together
    unique_digit_sets = np.vstack(unique_digit_sets)
    # we know that the digits will be 0-9 in order based on the above logic
    new_labels = np.arange(10)
    # data_set = np.vstack((unique_digit_sets, new_labels)).T
    return unique_digit_sets, new_labels


def k_means_clustering(image_data, image_labels, epsilon=0.01, max_iter=1000):
    # first start by computing the initial clusters
    # idx = np.sort(np.random.choice(len(image_data), k ,replace=False))
    # centroids = image_data[idx, :]
    centroids, sorted_labels = get_each_digit(image_data, image_labels)

    n_datasets = centroids.shape[0]

    k_by_1_corr_fn = cdist(image_data, centroids, 'seuclidean')

    points = np.array([np.argmin(i) for i in k_by_1_corr_fn])
    old_cent = centroids

    # plot initial clusters
    # fig1 = plt.figure()
    # ax1 = fig1.add_subplot(111)

    for i in range(max_iter):

        centroids = []
        labels = []
        for idx in range(n_datasets):
            temp_cent = image_data[points == idx].mean(axis=0)
            centroids.append(temp_cent)

        centroids = np.vstack(centroids)
        prior_estimation_error = np.sum(old_cent - centroids)
        print("Prior estimation error: ", prior_estimation_error)
        if np.abs(prior_estimation_error) < epsilon:
            print("Required prior estimation error reached.")
            break

        print("Iteration Number: ", i + 1)

        old_cent = centroids
        k_by_1_corr_fn = cdist(x, centroids, 'seuclidean')
        points = np.array([np.argmin(i) for i in k_by_1_corr_fn])

    # do plotting here

    return centroids



def cluster_digit_images(image_data_flat, n=10):
    # fix seed to obtain initial centroids
    np.random.seed(1)

    kmeans = KMeans(n_clusters=n, init='random')
    kmeans.fit(image_data_flat)
    clusters = kmeans.predict(image_data_flat)

    return clusters


def plot_clusters(clusters, image_data_flat, n=10, thin_factor=10):

    for i in range(n):

        # figure out the row of z corresponding to the ith cluster
        row = np.where(clusters == i)[0]
        num_elements = row.shape[0]

        #divide by 20 to thin the number of images to be plotted
        num_rows = np.floor((num_elements/n)/thin_factor)

        print("displaying cluster: " + str(i))
        print("With: " + str(num_elements) + " elements")

        plt.figure(figsize=(10, 10))

        # only going to plot every 20th element here
        plot_element = 0
        for r in range(0, num_elements, thin_factor):
            plt.subplot(num_rows+1, n, plot_element+1)
            image = image_data_flat[row[r], :]
            image = image.reshape(28, 28)
            plt.imshow(image)
            plt.axis('off')
            plot_element += 1

        plt.show()





if __name__ == "__main__":
    mnist = tf.keras.datasets.mnist
    (x_train, y_train), (x_test, y_test) = mnist.load_data()

    data_train = x_train.reshape(len(x_train), -1)
    data_test = x_test.reshape(len(x_test), -1)

    labels_train = y_train
    labels_test = y_test

    clusters = cluster_digit_images(data_test, 10)
    plot_clusters(clusters, data_test, 10)

