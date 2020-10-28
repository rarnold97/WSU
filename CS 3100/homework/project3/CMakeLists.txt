cmake_minimum_required(VERSION 3.17)
project(project3)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(project3
        all.last.txt
        LinkedNode.h
        LinkedSortedList.cpp
        LinkedSortedList.h
        main.cpp)
