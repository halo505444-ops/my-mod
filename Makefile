TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MamaHala

MamaHala_FILES = mod.xm
MamaHala_CFLAGS = -fobjc-arc
MamaHala_RESOURCES = MamaHala.jpg
MamaHala_FRAMEWORKS = UIKit AVFoundation

include $(THEOS_MAKE_PATH)/tweak.mk
