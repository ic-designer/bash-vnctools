# Constants
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
PREFIX ?= $(error ERROR: Undefined variable PREFIX)
BINDIR ?= $(error ERROR: Undefined variable BINDIR)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)

override NAME := vnctools
override PKGSUBDIR = $(NAME)/$(NAME)-$(VERSION)
override VERSION := $(shell git describe --always --dirty --broken)
override WORKDIR = $(WORKDIR_ROOT)/$(NAME)
override WORKDIR_BUILD = $(WORKDIR)/build
override WORKDIR_DEPS = $(WORKDIR)/deps
override WORKDIR_ROOT := $(CURDIR)/.make
override WORKDIR_TEST = $(WORKDIR)/test

# Includes
BOXERBIRD.MK := $(WORKDIR_DEPS)/boxerbird/boxerbird.mk
$(BOXERBIRD.MK):
	@echo "Loading Boxerbird..."
	git clone --config advice.detachedHead=false \
		git@github.com:ic-designer/make-boxerbird.git --branch 0.1.0 $(dir $@)
	@echo
-include $(BOXERBIRD.MK)

# Dependencies
WAXWING := $(WORKDIR_DEPS)/waxwing/bin/waxwing
$(WAXWING):
	@echo "Loading Waxwing..."
	git clone --config advice.detachedHead=false \
		git@github.com:ic-designer/bash-waxwing.git --branch main $(WORKDIR_DEPS)/waxwing
	@echo

BASHARGS := $(WORKDIR_BUILD)/lib/bashargs/bashargs.sh
$(BASHARGS):
	@echo "Installing bashargs..."
	git clone --config advice.detachedHead=false \
		git@github.com:ic-designer/bash-bashargs.git --branch 0.2.1 $(WORKDIR_DEPS)/bashargs
	$(MAKE) -C $(WORKDIR_DEPS)/bashargs install DESTDIR=$(abspath $(WORKDIR_BUILD)) LIBDIR=lib
	test -f $@
	@echo

# Private targets
.PHONY: private_all
private_all: \
		$(WORKDIR_BUILD)/vnctools-kill-$(VERSION) \
		$(WORKDIR_BUILD)/vnctools-list-$(VERSION) \
		$(WORKDIR_BUILD)/vnctools-open-$(VERSION) \
		$(WORKDIR_BUILD)/vnctools-start-$(VERSION)
	@for f in $^; do test -f $${f}; done

$(WORKDIR_BUILD)/vnctools-%-$(VERSION): \
		$(BASHARGS) \
		src/vnctools/vnctools-%.sh
	$(call boxerbird::build-bash-executable, main)


.PHONY: private_clean
private_clean:
	@echo "Cleaning directories:"
	@$(if $(wildcard $(WORKDIR)), rm -rfv $(WORKDIR))
	@$(if $(wildcard $(WORKDIR_BUILD)), rm -rfv $(WORKDIR_BUILD))
	@$(if $(wildcard $(WORKDIR_DEPS)), rm -rfv $(WORKDIR_DEPS))
	@$(if $(wildcard $(WORKDIR_ROOT)), rm -rfv $(WORKDIR_ROOT))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo


.PHONY: private_install
private_install: \
		$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-kill-$(VERSION) \
		$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-list-$(VERSION) \
		$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-open-$(VERSION) \
		$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-start-$(VERSION) \
		$(DESTDIR)/$(BINDIR)/vnctools-kill \
		$(DESTDIR)/$(BINDIR)/vnctools-list \
		$(DESTDIR)/$(BINDIR)/vnctools-open \
		$(DESTDIR)/$(BINDIR)/vnctools-start

$(DESTDIR)/$(BINDIR)/vnctools-%: $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION)
	$(call boxerbird::install-as-link)

$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION): $(WORKDIR_BUILD)/vnctools-%-$(VERSION)
	$(call boxerbird::install-as-executable)


.PHONY: private_test
private_test : $(WAXWING)
	@$(MAKE) install DESTDIR=$(abspath $(WORKDIR_TEST))
	@PATH=$(abspath $(WORKDIR_TEST)/$(BINDIR)):${PATH} $(WAXWING) test/vnctools


.PHONY: private_uninstall
private_uninstall:
	@echo "Uninstalling $(NAME)"
	@\rm -rdfv $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR) 2> /dev/null || true
	@\rm -dv $(dir $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)) 2> /dev/null || true
	@\rm -dv $(DESTDIR)/$(LIBDIR) 2> /dev/null || true
	@\rm -v $(DESTDIR)/$(BINDIR)/vnctools-* 2> /dev/null || true
	@\rm -dv $(DESTDIR)/$(BINDIR) 2> /dev/null || true
	@\rm -dv $(DESTDIR) 2> /dev/null || true
