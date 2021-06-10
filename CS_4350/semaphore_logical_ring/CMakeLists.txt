cmake_minimum_required(VERSION 3.16)

project(semaphore_implementation)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

#find system packages
find_package(Threads REQUIRED)

file(GLOB SOURCE_FILES
    *.c
    *.cpp
    *.h
)

add_executable(semaphore_implementation main.cpp  ${SOURCE_FILES})
target_link_libraries(semaphore_implementation Threads::Threads)