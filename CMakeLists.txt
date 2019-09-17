CMAKE_MINIMUM_REQUIRED(VERSION 3.2)
project(speechwrapc)
set(VERSION 0.1)

include (${CUSTOM_CMAKE_MODULES}/common.mk)

option(BUILD_DEBUG "debug or release" OFF)
option(USE_LIBUV "use libuv" OFF)

if(ANDROID) 
	set(ssl_find_args STATIC_LIBS ssl crypto)
else()
	set(ssl_find_args SHARED_LIBS ssl crypto)
endif()

findPackage(openssl REQUIRED
	HINTS ${OpenSSLPrefix}
	HEADERS openssl/ssl.h
	${ssl_find_args}
)
findPackage(zlib REQUIRED
	HINTS ${ZlibPrefix}
	HEADERS zlib.h
	SHARED_LIBS z
)
if (USE_LIBUV)
findPackage(libuv REQUIRED
  HINTS ${LibuvPrefix}
  HEADERS uv.h
  SHARED_LIBS uv
  RPATH
)
else()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUWS_THREADSAFE")
endif()

set(CMAKE_C_FLAGS "-pthread -fPIC")
set(CMAKE_CXX_FLAGS "-std=c++11")
if (BUILD_DEBUG)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0")
else()
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Os")
endif()
# workaround for g++ threading bug
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,--no-as-needed")
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
	${zlib_INCLUDE_DIRS}
	${libuv_INCLUDE_DIRS}
	src
)
target_link_libraries(uWS
	${openssl_LIBRARIES}
	${zlib_LIBRARIES}
	${libuv_LIBRARIES}
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


# demo: echo server
add_executable(echo examples/echo.cpp)
target_include_directories(echo PRIVATE
  src
  ${openssl_INCLUDE_DIRS}
  ${libuv_INCLUDE_DIRS}
)
target_link_libraries(echo
  uWS
)
