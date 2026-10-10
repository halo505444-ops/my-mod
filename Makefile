TARGET = libmod.dylib

ARCHS = arm64
SDKVERSION = iphoneos

THEOS_DEVICE_IP = 

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libmod

libmod_FILES = mod.xm
libmod_CFLAGS = -fobjc-arc
libmod_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/library.mk
