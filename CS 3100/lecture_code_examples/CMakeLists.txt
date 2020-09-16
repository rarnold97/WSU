cmake_minimum_required(VERSION 3.17)
project(lecture_code_examples)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)

add_executable(lecture_code_examples
        inputs/inputData.txt
        outputs/OutputData.txt
        intro_to_language.cpp
        intro_to_language.h
        main.cpp
        point.cpp
        point.h pointer.cpp)
