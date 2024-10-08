# Config
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --jobs
MAKEFLAGS += --check-symlink-times
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables
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
include test/vnctools/test-vnctools-waxwing.mk

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
		$(BASHARGS.SH) \
		src/vnctools/vnctools-functions.sh \
		src/vnctools/vnctools-%.sh
	$(call bowerbird::build-bash-executable,main)


.PHONY: private_clean
private_clean:
	@echo "Cleaning directories:"
	@$(if $(wildcard $(WORKDIR_BUILD)), rm -rfv $(WORKDIR_BUILD))
	@$(if $(wildcard $(WORKDIR_DEPS)), rm -rfv $(WORKDIR_DEPS))
	@$(if $(wildcard $(WORKDIR_ROOT)), rm -rfv $(WORKDIR_ROOT))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo


.PHONY: private_mostlyclean
private_mostlyclean:
	@echo "Cleaning directories:"
	@$(if $(wildcard $(WORKDIR_BUILD)), rm -rfv $(WORKDIR_BUILD))
	@$(if $(wildcard $(WORKDIR_TEST)), rm -rfv $(WORKDIR_TEST))
	@echo


.PHONY: private_install
private_install: $(foreach TOOL, $(VNCTOOL_LIST), $(DESTDIR)/$(BINDIR)/$(TOOL))

.PRECIOUS: $(DESTDIR)/$(BINDIR)/vnctools-%
$(DESTDIR)/$(BINDIR)/vnctools-%: $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-%
	$(call bowerbird::install-as-link)

.PRECIOUS: $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-%
$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-%: $(WORKDIR_BUILD)/vnctools-%
	$(call bowerbird::install-as-executable)


.PHONY: private_test
private_test: export VNCTOOLS_HISTORY_FILE=$(WORKDIR_TEST)/.vnctools-history
private_test: test-vnctools-makefile test-vnctools-waxwing
	printf "\e[1;32mPassed Tests\e[0m\n"

ifdef bowerbird::test::generate-runner
    $(call bowerbird::test::generate-runner,test-vnctools-makefile,test/makefile)
endif


.PHONY: private_uninstall
private_uninstall:
	@echo "Uninstalling $(NAME)"
	@\rm -rdfv $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR) 2> /dev/null || true
	@\rm -dv $(dir $(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)) 2> /dev/null || true
	@\rm -dv $(DESTDIR)/$(LIBDIR) 2> /dev/null || true
	@\rm -v $(DESTDIR)/$(BINDIR)/vnctools-* 2> /dev/null || true
	@\rm -dv $(DESTDIR)/$(BINDIR) 2> /dev/null || true
	@\rm -dv $(DESTDIR) 2> /dev/null || true
