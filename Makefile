ADDITIONAL_CCFLAGS  = -Qunused-arguments
THEOS_DEVICE_IP = 172.20.17.4
ARCHS = arm64
TARGET = iphone:latest:8.0


include theos/makefiles/common.mk

TWEAK_NAME = iOSDefectDynamicAnalyse
iOSDefectDynamicAnalyse_FILES = Tweak.xmi hooks/Utils.m hooks/SocketClass.m hooks/CustomURLProtocol.m hooks/CCCryptHook.m hooks/SSLWriteHook.m

iOSDefectDynamicAnalyse_FRAMEWORKS = UIKit Security Foundation

include $(THEOS_MAKE_PATH)/tweak.mk


