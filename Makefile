.PHONY: deb tbd extract clean install

export INSTALL_PATH = /var/lib/libswift/
export STAGE = .stage
export V

DEVICE_IP ?= $(THEOS_DEVICE_IP)
DEVICE_PORT ?= $(THEOS_DEVICE_PORT)

package:: package-check extract
	@bin/deb

package-check::
ifeq ($(V),)
	@echo "Please set V(ersion) in your environment (eg. export V=3)"
	@exit 1
endif

tbd:: extract
	@bin/tbd

extract::
	@bin/extract

clean::
	@rm -rf $(STAGE)

install::
ifeq ($(DEVICE_IP),)
	@echo "Error: $(MAKE) install requires that you set DEVICE_IP or THEOS_DEVICE_IP in your environment."
	@exit 1
else
	@ssh root@$(DEVICE_IP) -p $(DEVICE_PORT) "cat > /tmp/_theos_install.deb; dpkg -i /tmp/_theos_install.deb && rm /tmp/_theos_install.deb" < $$(cat debs/.latest)
endif
