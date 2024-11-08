cmake_minimum_required(VERSION 3.22)

set(CMAKE_OSX_ARCHITECTURES "arm64e")

project(smc-interpose CXX Swift)

add_library(smcswift STATIC src/run.swift src/SMC.swift)
target_compile_options(smcswift PRIVATE -cxx-interoperability-mode=default
                                        -target arm64e-apple-macos14.2)

add_library(smc SHARED src/interpose.cpp)
target_link_libraries(smc PRIVATE ${CMAKE_BINARY_DIR}/libsmcswift.a)
