# Makefile for Android Milestone2 kernel-omap tree
# "make device_modules" in repo root (not here)


# list of modules to build :
obj-m += symsearch/
obj-m += overclock/
obj-m += backlight/
#obj-m += debounce/
#obj-m += qtouch_num/
#obj-m += mmcfix/
#obj-m += gpiofix/
#obj-m += clockfix/
#obj-m += logcap/
#obj-m += netfilter/
#obj-m += thumbee/
#obj-m += qtouch_obp_ts/
#obj-m += pvr/
#obj-m += klogger/
obj-m += tls/
obj-m += hbootmod/


# experimental
#obj-m += ion/


PWD := $(shell pwd)

.PHONY: clean
#######################################################################################
clean:
	@find $(PWD) | grep "\\.o$$" | xargs rm -f
	@find $(PWD) | grep "\\.ko$$" | xargs rm -f
	@find $(PWD) | grep "\\.cmd$$" | xargs rm -f
	@find $(PWD) | grep "\\.mod.c$$" | xargs rm -f
	@find $(PWD) | grep "\\.order$$" | xargs rm -f
	@find $(PWD) | grep "\\.tmp_versions$$" | xargs rm -rf
	@cd $(PWD) && git checkout *.ko


EXTRA_CFLAGS += -I$(KERNEL_DIR)

.PHONY: all
#######################################################################################
# Build the modules
#######################################################################################
all: modules
modules:
	pwd
	@echo $@ EXTRA_CFLAGS = $(EXTRA_CFLAGS)
	$(MAKE) CROSS_COMPILE=$(CROSS_COMPILE) EXTRA_CFLAGS="$(EXTRA_CFLAGS)" ARCH=$(ARCH) -C $(KERNEL_DIR) M=$(PWD) modules
	@find $(PWD) | grep "\\.o$$" | xargs rm -f
	@find $(PWD) | grep "\\.cmd$$" | xargs rm -f
	@find $(PWD) | grep "\\.mod.c$$" | xargs rm -f
	@find $(PWD) | grep "\\.order$$" | xargs rm -f
	@find $(PWD) | grep "\\.tmp_versions$$" | xargs rm -rf


