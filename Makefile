ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1
export THEOS=/var/theos
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 7AMOD

# ئەم فەرمانە خۆی هەموو فایلەکانی ناو سەرجەم فۆڵدەرەکان دەدۆزێتەوە و دەیانخاتە ناو دایلیبەکەوە
7AMOD_FILES = Tweak.xm $(shell find . -name "*.m" -o -name "*.mm" -o -name "*.cpp" -o -name "*.c")

7AMOD_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
7AMOD_CFLAGS = -fobjc-arc -w -Wno-deprecated -Wno-deprecated-declarations -I./
7AMOD_LDFLAGS = -z muldefs
7AMOD_LIBRARIES += substrate

include $(THEOS_MAKE_PATH)/tweak.mk
