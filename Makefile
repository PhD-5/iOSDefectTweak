ADDITIONAL_CCFLAGS  = -Qunused-arguments
THEOS_DEVICE_IP = 172.24.35.5
ARCHS = arm64 armv7
TARGET = iphone:latest:8.0


include theos/makefiles/common.mk

TWEAK_NAME = iOSDefectDynamicAnalyse
iOSDefectDynamicAnalyse_FILES = Tweak.xmi hooks/Utils.m hooks/SocketClass.m hooks/CustomURLProtocol.m hooks/CCCryptHook.m hooks/SSLWriteHook.m hooks/DelegateProxies.m hooks/KeychainHooks.m

iOSDefectDynamicAnalyse_FRAMEWORKS = UIKit Security Foundation
iOSDefectDynamicAnalyse_LIBRARIES = sqlite3 substrate

include $(THEOS_MAKE_PATH)/tweak.mk


