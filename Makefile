ARCHS = arm64
TARGET = iphone:clang:latest:11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MamaHala
MamaHala_FILES = mod.m
MamaHala_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
