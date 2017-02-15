.PHONY: copy clean install

export INSTALL_PATH = /var/lib/libswift/
export STAGE = .stage
export V ?= $(shell ls versions|tail -1|cut -d. -f1)

DEVICE_IP ?= $(THEOS_DEVICE_IP)
DEVICE_PORT ?= $(THEOS_DEVICE_PORT)

ifeq ($(SWIFT),)
SWIFT := $(word 4,$(shell swift --version))
TOOLCHAIN = XcodeDefault
else
TOOLCHAIN = Swift_$(SWIFT)
endif

ifeq ($(XCODE),)
XCODE := $(shell xcode-select -p)
else
XCODE := $(XCODE)/Contents/Developer
endif

package::
	@bin/deb

copy::
	@rm -rf versions/$(SWIFT)
	@mkdir -p versions/$(SWIFT)
	@cp "$(XCODE)"/Toolchains/$(TOOLCHAIN).xctoolchain/usr/lib/swift/iphoneos/*.dylib versions/$(SWIFT) || rm -rf versions/$(SWIFT)

clean::
	@rm -rf $(STAGE)

install::
ifeq ($(DEVICE_IP),)
	@echo "Error: $(MAKE) install requires that you set DEVICE_IP or THEOS_DEVICE_IP in your environment."
	@exit 1
else
	@ssh root@$(DEVICE_IP) -p $(or $(DEVICE_PORT),22) "cat > /tmp/_theos_install.deb; dpkg -i /tmp/_theos_install.deb && rm /tmp/_theos_install.deb" < $$(cat debs/.latest)
endif
