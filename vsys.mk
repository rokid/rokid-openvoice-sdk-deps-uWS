local-path := $(call my-dir)

include $(clear-vars)
local.module := uWS
local.ndk-script := $(local-path)/ndk.mk
include $(build-ndk-module)
