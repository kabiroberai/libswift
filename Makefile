INSTALL_PATH := /usr/lib/libswift
NULL_NAME := libswift
BUILD := 3

VERSIONS = $(wildcard versions/4.*)
PACKAGE_VERSION = $(lastword $(notdir $(VERSIONS)))-$(BUILD)

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/null.mk

.PHONY: FORCE

PACKAGE_LIBSWIFT_PATH := usr/lib/swift/iphoneos
FILE = $(notdir $*)
PACKAGE = $(FILE)-package.pkg
VERSION = $(patsubst swift-%-RELEASE-osx,%,$(FILE))

# unpack the pkg and change each dylib's compatibility version to 1.0.0
%.pkg:: FORCE
	$(ECHO_NOTHING)mkdir -p versions; \
	cd versions; \
	$(PRINT_FORMAT_STAGE) 2 "Extracting toolchain: $(VERSION)"; \
	xar -xf "$@" "$(PACKAGE)/Payload"; \
	tar -xzf "$(PACKAGE)/Payload" "$(PACKAGE_LIBSWIFT_PATH)/libswift*.dylib"; \
	rm -rf "$(VERSION)" "$(PACKAGE)"; \
	mv "$(PACKAGE_LIBSWIFT_PATH)" "$(VERSION)"; \
	rm -rf usr; \
	../libswift_edit "$(VERSION)"/*$(ECHO_END)

FORCE:

stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/$(INSTALL_PATH); \
	rsync -ra $(VERSIONS) $(THEOS_STAGING_DIR)/$(INSTALL_PATH) $(_THEOS_RSYNC_EXCLUDE_COMMANDLINE); \
	for version in $(THEOS_STAGING_DIR)/$(INSTALL_PATH)/*; do \
		cp NOTICE.txt $$version/; \
	done$(ECHO_END)

ifeq ($(VERSIONS),)
internal-package-check::
	$(ECHO_NOTHING)$(PRINT_FORMAT_ERROR) "Please extract a toolchain before packaging.";exit 1$(ECHO_END)
endif
