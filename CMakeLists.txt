cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(argon2 C)

# Compile libargon2.a (core static library)
add_custom_target(
    static_argon2
    COMMAND CFLAGS=-fPIC make -C phc-winner-argon2
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    VERBATIM
)

if (APPLE)
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -undefined suppress -flat_namespace")
endif(APPLE)

# Find Tarantool and Lua dependecies
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
set(TARANTOOL_FIND_REQUIRED ON)
find_package(Tarantool REQUIRED)
include_directories(${TARANTOOL_INCLUDE_DIRS})

# Add C library
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/phc-winner-argon2/include)
add_library(argon2 SHARED src/argon2.c)

# Link with libargon2.a (core static library)
add_dependencies(argon2 static_argon2)
target_link_libraries(argon2 ${CMAKE_CURRENT_SOURCE_DIR}/phc-winner-argon2/libargon2.a)

set_target_properties(argon2 PROPERTIES PREFIX "")

# Install module
install(TARGETS argon2 LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/${TARANTOOL_INSTALL_LIBDIR})

