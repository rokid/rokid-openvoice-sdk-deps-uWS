CMAKE_MINIMUM_REQUIRED(VERSION 3.2)
project(speechwrapc)
set(VERSION 0.1)

include (${CUSTOM_CMAKE_MODULES}/common.mk)

option(BUILD_DEBUG "debug or release" OFF)

findPackage(openssl REQUIRED
	HINTS ${OpenSSLPrefix}
	HEADERS openssl/ssl.h
	SHARED_LIBS crypto ssl
)

set(CMAKE_C_FLAGS "-pthread -fPIC")
set(CMAKE_CXX_FLAGS "-std=c++11")
if (BUILD_DEBUG)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")
else()
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Os")
	set(CMAKE_SHARED_LINKER_FLAGS "-s")
	set(CMAKE_EXE_LINKER_FLAGS "-s")
endif()
# workaround for g++ threading bug
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,--no-as-needed")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUWS_THREADSAFE")
if (CROSS_COMPILE_CXXFLAGS)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CROSS_COMPILE_CXXFLAGS}")
endif()

file(GLOB_RECURSE UWS_SOURCES 
	src/*.h
	src/*.cpp
)

add_library(uWS SHARED
	${UWS_SOURCES}
)
target_include_directories(uWS PRIVATE
	${openssl_INCLUDE_DIRS}
	src
)
target_link_libraries(uWS
	${openssl_LIBRARIES}
)

# install include files.
file(GLOB UWS_HEADERS
	src/*.h
)
install(FILES ${UWS_HEADERS}
	DESTINATION include/uWS
	PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
)
install(TARGETS uWS
	LIBRARY DESTINATION lib
)
