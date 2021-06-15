cmake_minimum_required(VERSION 3.16)

project(server_client LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

#find system packages
find_package(Threads REQUIRED)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
file(GLOB SOURCE_FILES *.h)

add_executable(server server.cpp ${SOURCE_FILES})
target_link_libraries(server Threads::Threads)

add_executable(client client.cpp ${SOURCE_FILES})
target_link_libraries(client Threads::Threads)
