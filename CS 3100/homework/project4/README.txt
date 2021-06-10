/*
CS 3100 Data Structures and Algorithms
Ryan Arnold
Dr.Meilin Liu
December. 1, 2020
Project 4: Binary Search Tree
*/

# HOW TO RUN:

* the entry point to the code is in main.cpp
* all of the test and example code is contained within main.cpp
* to run, make sure that all source files are included in the working directory
* to read the input file, Small-Database.txt , make sure that this is either:
    1. in the same directory as the binary
    2. the file is in the project directory and the VS 2019 Working directory is set to where the source and input files are


# Binary Tree Node

* stores a pointer to the left and right children nodes as well as the parent node
* stores a value that is an object of the Employee class
* by default the root parent is NULL
* contains many helper functions
    ** Operator overloads for < , > , and ==.  Uses the ID stored in the Employee object as arguments to the logical expressions
    ** helper functions for getting the employee object stored in the node (getElement, getElementPtr)
    ** includes setters to store new pointers, i.e., setRight, setLeft, setParent
    ** has checker functions.  For example, checks if its the root in isRoot
    ** includes optional function to retrieve the ID key in getKey

# BinarySearchTree Interface

* member variables include a count of the number of nodes as well as a pointer to the root node.
* constructor by default sets the root to be null.
* destructor uses postorder tree traversal to delete the dynamic memory assigned to the nodes.  Calls clear() to accomplish this
* clear() is the method that actually implements a postorder traversal deletion
* insert() accepts an employee object and inserts the element to the correct location according to its key.
* search() will accept an ID int and navigate the binary search tree and print the employee object to the screen or
  indicate if the employee was found.  Also prints the number of elements traversed while looking for the node
* remove performs a binary search tree deletion on an ID key and returns true or false if it was successful or not in doing so
* BSTsize() returns the number of nodes stored in the tree
* print() performs an inorder traversal of the tree and prints all of the elements in that order to the screen
* save() does the same as print(), except the values are written to a text file instead of displayed to the screen.
  A boolean is returned to indicate whether the operation was successful or not.
* getRoot() returns a constant pointer reference to the root node.

# Helper Functions

* getRightMost() will find and return the rightmost child node of a given node.  returns NULL if there are no right children
* geLeftMost() will do the same as RightMost for the leftmost child node.
* DeleteNode() is a helper function to safely free memory used by nodes
* recursivePrint() is a recursive function used to execute the inorder printing algorithm used in the print() driver function
* recursiveSave() is a recursive function used to execute the inorder saving algorithm used in the save() driver function


