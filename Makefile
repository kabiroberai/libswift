INSTALL_PATH := /usr/lib/libswift/stable
NULL_NAME := libswift
BUILD := 1

VERSIONS = $(wildcard versions/*)
VERSION ?= $(notdir $(lastword $(VERSIONS)))
VERSION_PATH = versions/$(VERSION)
PACKAGE_VERSION = $(VERSION)-$(BUILD)$(_LOCAL_PACKAGE_VERSION_SUFFIX)

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk

ifeq ($(call __theos_bool,$(or $(debug),$(DEBUG))),$(_THEOS_TRUE))
	_LOCAL_PACKAGE_VERSION_SUFFIX = +debug
endif

.PHONY: FORCE
FORCE:

PACKAGE_LIBSWIFT_PATH := usr/lib/swift/iphoneos
FILE = $(notdir $*)
PACKAGE = $(FILE)-package.pkg
TOOLCHAIN_FULL_VERSION = $(patsubst swift-%-osx,%,$(FILE))
TOOLCHAIN_VERSION = $(firstword $(subst -, ,$(TOOLCHAIN_FULL_VERSION)))

# unpack the pkg and change each dylib's compatibility version to 1.0.0
%.pkg:: FORCE
	$(ECHO_NOTHING)mkdir -p versions; \
	cd versions; \
	$(PRINT_FORMAT_STAGE) 2 "Extracting toolchain: $(TOOLCHAIN_VERSION)"; \
	xar -xf "$@" "$(PACKAGE)/Payload"; \
	tar -xzf "$(PACKAGE)/Payload" "$(PACKAGE_LIBSWIFT_PATH)/libswift*.dylib"; \
	rm -rf "$(TOOLCHAIN_VERSION)" "$(PACKAGE)"; \
	mv "$(PACKAGE_LIBSWIFT_PATH)" "$(TOOLCHAIN_VERSION)"; \
	rm -rf usr; \
	../libswift_edit "$(TOOLCHAIN_VERSION)"/*; \
	ldid -S "$(TOOLCHAIN_VERSION)"/*$(ECHO_END)

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
