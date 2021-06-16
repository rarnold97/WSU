cmake_minimum_required(VERSION 3.16)

project(indirect_message)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

#find system packages
#find_package(Threads REQUIRED)

file(GLOB SOURCE_FILES
    *.h
)

add_executable(send message_send.cpp  ${SOURCE_FILES})
add_executable(receive message_receive.cpp  ${SOURCE_FILES})