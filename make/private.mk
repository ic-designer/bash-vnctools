# Config
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --warn-undefined-variables

# Constants
NAME := vnctools
VERSION := $(shell git describe --always --dirty --broken 2> /dev/null)

# Paths
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
PREFIX ?= $(error ERROR: Undefined variable PREFIX)
BINDIR ?= $(error ERROR: Undefined variable BINDIR)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)
WORKDIR_ROOT ?= $(error ERROR: Undefined variable WORKDIR_ROOT)
override WORKDIR_BUILD = $(WORKDIR_ROOT)/build/$(NAME)/$(VERSION)
override WORKDIR_DEPS = $(WORKDIR_ROOT)/deps
override WORKDIR_TEST = $(WORKDIR_ROOT)/test/$(NAME)/$(VERSION)
override PKGSUBDIR = $(NAME)

# Includes
include make/deps.mk
include test/makefile/test-makefile.mk
include test/vnctools/test-vnctools.mk
include $(BOXERBIRD.MK)

# Targets
override VNCTOOL_LIST := \
		vnctools-connect \
		vnctools-history \
		vnctools-kill \
		vnctools-list \
		vnctools-open \
		vnctools-start \

.PHONY: private_all
private_all: $(foreach TOOL, $(VNCTOOL_LIST), $(WORKDIR_BUILD)/$(TOOL))
	@for f in $^; do test -f $${f}; done

$(WORKDIR_BUILD)/vnctools-%: \
		$(WORKDIR_BUILD)/lib/bashargs/bashargs.sh \
		src/vnctools/vnctools-functions.sh \
		src/vnctools/vnctools-%.sh
	$(call boxerbird::build-bash-executable, main)

$(WORKDIR_BUILD)/lib/bashargs/bashargs.sh: $(BASHARGS_REPO)
	@echo "Building bashargs..."
	$(MAKE) -C $(BASHARGS_REPO) install \
			DESTDIR=$(WORKDIR_BUILD) LIBDIR=lib WORKDIR_ROOT=$(WORKDIR_ROOT)
	test -f $@
	@echo


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
private_test : export VNCTOOLS_HISTORY_FILE=$(WORKDIR_TEST)/.vnctools-history
private_test : test-makefile test-vnctools


.PHONY: private_uninstall
private_uninstall:
	@echo "Uninstalling $(NAME)"
	@\rm -rdfv $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR) 2> /dev/null || true
	@\rm -dv $(dir $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)) 2> /dev/null || true
	@\rm -dv $(DESTDIR)/$(LIBDIR) 2> /dev/null || true
	@\rm -v $(DESTDIR)/$(BINDIR)/vnctools-* 2> /dev/null || true
	@\rm -dv $(DESTDIR)/$(BINDIR) 2> /dev/null || true
	@\rm -dv $(DESTDIR) 2> /dev/null || true
