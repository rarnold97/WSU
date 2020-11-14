cmake_minimum_required(VERSION 3.17)
project(project4)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(project4
        BinarySearchTree.h
        BinaryTreeNode.h
        Small-Database.txt main.cpp BinarySearchTree.cpp BinaryTreeNode.cpp)
