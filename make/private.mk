# Constants
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
PREFIX ?= $(error ERROR: Undefined variable PREFIX)
BINDIR ?= $(error ERROR: Undefined variable BINDIR)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)
WORKDIR_ROOT ?= $(error ERROR: Undefined variable WORKDIR_ROOT)

override NAME := vnctools
override PKGSUBDIR = $(NAME)
override VERSION := $(shell git describe --always --dirty --broken 2> /dev/null)
override WORKDIR_BUILD = $(WORKDIR_ROOT)/build/$(NAME)/$(VERSION)
override WORKDIR_DEPS = $(WORKDIR_ROOT)/deps
override WORKDIR_TEST = $(WORKDIR_ROOT)/test/$(NAME)/$(VERSION)

# Includes
BOXERBIRD_VERSION := 0.1.0
BOXERBIRD.MK = $(WORKDIR_DEPS)/make-boxerbird-$(BOXERBIRD_VERSION)/boxerbird.mk
$(BOXERBIRD.MK):
	@echo "Loading boxerbird..."
	mkdir -p $(WORKDIR_DEPS)
	curl -sL https://github.com/ic-designer/make-boxerbird/archive/refs/tags/$(BOXERBIRD_VERSION).tar.gz | tar xz -C $(WORKDIR_DEPS)
	test -f $@
	@echo
include $(BOXERBIRD.MK)

# Dependencies
WAXWING := $(WORKDIR_DEPS)/waxwing/bin/waxwing
$(WAXWING):
	@echo "Loading waxwing..."
	git clone --config advice.detachedHead=false git@github.com:ic-designer/bash-waxwing.git --branch main $(WORKDIR_DEPS)/waxwing
	test -f $@
	@echo

BASHARGS.SH := $(WORKDIR_BUILD)/lib/bashargs/bashargs.sh
BASHARGS_VERSION := 0.2.1
$(BASHARGS.SH): |$(WORKDIR_DEPS)/.
	@echo "Loading bashargs..."
	curl -sL https://github.com/ic-designer/bash-bashargs/archive/refs/tags/$(BASHARGS_VERSION).tar.gz | tar xz -C $(WORKDIR_DEPS)
	$(MAKE) -C $(WORKDIR_DEPS)/bash-bashargs-$(BASHARGS_VERSION) install DESTDIR=$(WORKDIR_BUILD) LIBDIR=lib
	test -f $@
	@echo

# Private targets
override VNCTOOL_LIST := vnctools-kill vnctools-list vnctools-open vnctools-start

.PHONY: private_all
private_all: $(foreach TOOL, $(VNCTOOL_LIST), $(WORKDIR_BUILD)/$(TOOL))
	@for f in $^; do test -f $${f}; done

$(WORKDIR_BUILD)/vnctools-%: \
		$(BASHARGS.SH) \
		src/vnctools/vnctools-%.sh
	$(call boxerbird::build-bash-executable, main)


.PHONY: private_clean
private_clean:
	@echo "Cleaning directories:"
	@$(if $(wildcard $(WORKDIR_BUILD)), rm -rfv $(WORKDIR_BUILD))
	@$(if $(wildcard $(WORKDIR_DEPS)), rm -rfv $(WORKDIR_DEPS))
	@$(if $(wildcard $(WORKDIR_ROOT)), rm -rfv $(WORKDIR_ROOT))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo


.PHONY: private_install
private_install: \
		$(foreach TOOL, $(VNCTOOL_LIST), $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/$(TOOL)) \
		$(foreach TOOL, $(VNCTOOL_LIST), $(DESTDIR)/$(BINDIR)/$(TOOL))

$(DESTDIR)/$(BINDIR)/vnctools-%: $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-%
	$(call boxerbird::install-as-link)

$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-%: $(WORKDIR_BUILD)/vnctools-%
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
