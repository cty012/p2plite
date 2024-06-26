cmake_minimum_required(VERSION 3.22)

# CMake cache variables
option(BUILD_EXAMPLES "Build the example programs in the `examples/` folder." ON)
option(BUILD_TESTS "Build the test cases in the `test/` folder." OFF)

if (BUILD_TESTS)
    enable_testing()
    set(VCPKG_MANIFEST_FEATURES "${VCPKG_MANIFEST_FEATURES};tests")
endif ()

#Project settings
project(p2plite VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 20)
set(DEPS_PATH "${CMAKE_SOURCE_DIR}/deps")
list(APPEND CMAKE_PREFIX_PATH "${DEPS_PATH}")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Output directories
set(EXAMPLES_OUTPUT_DIR "${CMAKE_BINARY_DIR}/examples")
set(TEST_OUTPUT_DIR "${CMAKE_BINARY_DIR}/tests")

# Compiler flags
if (MSVC)
    add_compile_options(/utf-8 /W4 /WX)
    add_compile_options("$<$<CONFIG:Release>:/O2>")
    add_compile_options("$<$<CONFIG:Debug>:/Zi>")
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
else ()
    add_compile_options(-Wall -Wextra -Werror)
    add_compile_options("$<$<CONFIG:Release>:-O3>")
    add_compile_options("$<$<CONFIG:Debug>:-g>")
endif ()

# For static analysis and linting
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# P2P Lite target
file(GLOB_RECURSE HEADERS
        "${CMAKE_SOURCE_DIR}/include/*.h"
        "${CMAKE_SOURCE_DIR}/include/*.cpp"
)
file(GLOB_RECURSE SOURCES
        "${CMAKE_SOURCE_DIR}/src/*.h"
        "${CMAKE_SOURCE_DIR}/src/*.cpp"
)

add_library(p2plite ${HEADERS} ${SOURCES})
set_target_properties(p2plite PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY "${P2PLITE_OUTPUT_DIR}"
        DEBUG_POSTFIX -d
)
set(P2PLITE_OUTPUT_PATH $<TARGET_FILE:p2plite>)
target_include_directories(p2plite PRIVATE "${CMAKE_SOURCE_DIR}/include")

# Link with GLib
find_package(GLib REQUIRED)
target_include_directories(p2plite PRIVATE ${GLIB_INCLUDE_DIRS})
target_link_libraries(p2plite PRIVATE ${GLIB_LIBRARIES})

# Link with libnice
find_package(libnice REQUIRED)
target_link_libraries(p2plite PRIVATE libnice::libnice)

# Build examples
if (BUILD_EXAMPLES)
    add_subdirectory("examples")
endif ()

# Build test cases
if (BUILD_TESTS)
    add_subdirectory("test")
endif ()

# Install
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/dist/p2plite-${PROJECT_VERSION}-${PLATFORM}")
install(TARGETS p2plite
        RUNTIME DESTINATION "bin"
        LIBRARY DESTINATION "bin"
        ARCHIVE DESTINATION "lib"
)
install(DIRECTORY "${CMAKE_SOURCE_DIR}/include/p2plite" DESTINATION "include")

configure_file(p2plite-config.cmake.in p2plite-config.cmake @ONLY)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/p2plite-config.cmake" DESTINATION "cmake")
