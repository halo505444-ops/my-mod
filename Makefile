TARGET := iphone:clang:latest:13.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 7AMOD

7AMOD_FILES = Tweak.xm KittyMemory/KittyMemory.cpp KittyMemory/MemoryPatch.cpp KittyMemory/MemoryBackup.cpp KittyMemory/KittyUtils.cpp
7AMOD_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -fno-modules -fno-builtin
7AMOD_CFLAGS = -fobjc-arc -w -fno-modules -fno-builtin
7AMOD_LDFLAGS = -z muldefs
7AMOD_LIBRARIES += substrate

include $(THEOS_MAKE_PATH)/tweak.mk
