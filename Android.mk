LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := libuWS
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := \
	src/Epoll.cpp \
	src/Extensions.cpp \
	src/Group.cpp \
	src/HTTPSocket.cpp \
	src/Hub.cpp \
	src/Networking.cpp \
	src/Node.cpp \
	src/Socket.cpp \
	src/WebSocket.cpp
LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/src \
	external/zlib
LOCAL_SHARED_LIBRARIES := libssl libcrypto libz
LOCAL_CPPFLAGS := -std=c++11 -fexceptions -DUWS_THREADSAFE
ifeq ($(PLATFORM_SDK_VERSION), 22)
LOCAL_SHARED_LIBRARIES += libc++ libdl
LOCAL_C_INCLUDES += external/openssl/include
else ifeq ($(PLATFORM_SDK_VERSION), 19)
LOCAL_SDK_VERSION := 14
LOCAL_NDK_STL_VARIANT := gnustl_static
LOCAL_C_INCLUDES += external/openssl/include
else
LOCAL_CXX_STL := libc++
LOCAL_C_INCLUDES += external/boringssl/include
endif
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/src
include $(BUILD_SHARED_LIBRARY)
