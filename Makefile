INSTALL_PATH := /usr/lib/libswift/stable
NULL_NAME := libswift
BUILD := 1

VERSIONS = $(wildcard versions/*)
VERSION ?= $(notdir $(lastword $(VERSIONS)))
VERSION_PATH = versions/$(VERSION)
PACKAGE_VERSION = $(VERSION)-$(BUILD)$(_LOCAL_PACKAGE_VERSION_SUFFIX)

XCODE = $(shell xcode-select -p)/../..
XCODE_USR = $(XCODE)/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr
EXTRACT_VERSION = $(shell $(XCODE_USR)/bin/swift --version | head -1 | cut -f4 -d" ")
EXTRACT_DIR = versions/$(EXTRACT_VERSION)

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk

ifeq ($(call __theos_bool,$(or $(debug),$(DEBUG))),$(_THEOS_TRUE))
	_LOCAL_PACKAGE_VERSION_SUFFIX = +debug
endif

.PHONY: FORCE extract
FORCE:

extract::
	$(ECHO_NOTHING)mkdir -p $(EXTRACT_DIR)$(ECHO_END)
	$(ECHO_NOTHING)rsync -ra "$(XCODE_USR)/lib/swift/iphoneos"/libswift*.dylib $(EXTRACT_DIR) $(_THEOS_RSYNC_EXCLUDE_COMMANDLINE)$(ECHO_END)
	$(ECHO_NOTHING)ldid -S $(EXTRACT_DIR)/*$(ECHO_END)

stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/$(INSTALL_PATH)$(ECHO_END)
	$(ECHO_NOTHING)rsync -ra $(VERSION_PATH)/ $(THEOS_STAGING_DIR)/$(INSTALL_PATH) $(_THEOS_RSYNC_EXCLUDE_COMMANDLINE)$(ECHO_END)
	$(ECHO_NOTHING)cp NOTICE.txt $(VERSION_PATH)/$(ECHO_END)

ifeq ($(lastword $(VERSIONS)),)
internal-package-check::
	$(ECHO_NOTHING)$(PRINT_FORMAT_ERROR) "Please extract a toolchain before packaging.";exit 1$(ECHO_END)
else 
ifeq ($(call __exists,$(VERSION_PATH)),$(_THEOS_FALSE))
internal-package-check::
	$(ECHO_NOTHING)$(PRINT_FORMAT_ERROR) "Version $(VERSION) has not been extracted.";exit 1$(ECHO_END)
endif
endif
