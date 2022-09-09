CMAKE_MINIMUM_REQUIRED(VERSION 3.2)
project(uWS)
set(VERSION 0.1)

option(USE_LIBUV "use libuv" OFF)
option(BUILD_DEMO "build demo" OFF)

find_package(OpenSSL REQUIRED)
find_package(ZLIB REQUIRED)
if (USE_LIBUV)
find_package(PkgConfig REQUIRED)
pkg_check_modules(libuv REQUIRED IMPORTED_TARGET libuv)
else()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUWS_THREADSAFE")
endif()
find_package(Threads REQUIRED)
set(CMAKE_CXX_STANDARD 11)
if (CROSS_COMPILE_CXXFLAGS)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CROSS_COMPILE_CXXFLAGS}")
endif()

file(GLOB_RECURSE UWS_SOURCES 
	src/*.h
	src/*.cpp
)

add_library(uWS
	${UWS_SOURCES}
)
target_include_directories(uWS INTERFACE
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
  $<INSTALL_INTERFACE:include/uWS>
)
target_link_libraries(uWS PRIVATE
  OpenSSL::Crypto
  OpenSSL::SSL
  ZLIB::ZLIB
  Threads::Threads
)
if (USE_LIBUV)
  target_link_libraries(uWS PUBLIC PkgConfig::libuv)
endif()
if (NOT BUILD_SHARED_LIBS)
  set_target_properties(uWS PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()
if (NOT USE_LIBUV)
  target_compile_options(uWS PUBLIC -DUWS_THREADSAFE)
endif()

file(GLOB UWS_HEADERS
	src/*.h
)
set_target_properties(uWS PROPERTIES PUBLIC_HEADER "${UWS_HEADERS}")
install(TARGETS uWS
  EXPORT uWS-config
	LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  PUBLIC_HEADER DESTINATION include/uWS
)
install(EXPORT uWS-config
  DESTINATION lib/cmake/uWS
  NAMESPACE uWS::
)

# demo: echo server
if (BUILD_DEMO)
add_executable(echo examples/echo.cpp)
target_link_libraries(echo
  uWS
)
endif(BUILD_DEMO)
