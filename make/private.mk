# Constants
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
PREFIX ?= $(error ERROR: Undefined variable PREFIX)
BINDIR ?= $(error ERROR: Undefined variable BINDIR)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)

NAME ?= $(error ERROR: Undefined variable NAME)
VERSION ?= $(error ERROR: Undefined variable VERSION)
WORKDIR_ROOT ?= $(error ERROR: Undefined variable WORKDIR_ROOT)

override PKGSUBDIR = $(NAME)/$(NAME)-$(VERSION)
override WORKDIR = $(WORKDIR_ROOT)/$(NAME)
override WORKDIR_BUILD = $(WORKDIR)/build
override WORKDIR_DEPS = $(WORKDIR)/deps
override WORKDIR_TEST = $(WORKDIR)/test

# Includes
include make/extras.mk

# Dependencies
WAXWING := $(WORKDIR_DEPS)/waxwing/bin/waxwing
$(WAXWING): |$(WORKDIR_DEPS)/.
	$(call git-clone-shallow, \
			git@github.com:ic-designer/waxwing.git, \
			$(WORKDIR_DEPS)/waxwing, main)

$(WORKDIR_BUILD)/bashargs/bashargs.sh: | $(WORKDIR_DEPS)/.
	$(call git-clone-shallow, \
			git@github.com:ic-designer/bash-bashargs.git, \
			$(WORKDIR_DEPS)/bash-bashargs, 0.2.0)
	$(MAKE) -C $(WORKDIR_DEPS)/bash-bashargs install DESTDIR=$(abspath $(WORKDIR_BUILD)) LIBDIR=
	test -f $@

# Private targets
.PHONY: private_all
private_all: \
		$(WORKDIR_BUILD)/vnctools-kill-$(VERSION) \
		$(WORKDIR_BUILD)/vnctools-list-$(VERSION) \
		$(WORKDIR_BUILD)/vnctools-open-$(VERSION) \
		$(WORKDIR_BUILD)/vnctools-start-$(VERSION)
	@for f in $^; do test -f $${f}; done

$(WORKDIR_BUILD)/vnctools-%-$(VERSION): \
		$(WORKDIR_BUILD)/bashargs/bashargs.sh \
		src/vnctools/vnctools-%.sh
	$(call build-bash-executable, main)


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
	$(call install-as-link)

$(DESTDIR)/$(LIBDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION): $(WORKDIR_BUILD)/vnctools-%-$(VERSION)
	$(call install-as-executable)


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


.PHONY: private_pkg_list
private_pkg_list:
	$(call git-list-remotes, $(WORKDIR_DEPS))


.PHONY: private_pkg_override
private_pkg_override: REPO_NAME ?= $(error ERROR: Name not defined. Please defined REPO_NAME=<name>)
private_pkg_override: REPO_PATH ?= $(error ERROR: Repo not defined. Please defined REPO_PATH=<path>)
private_pkg_override:
	$(call git-clone-shallow, $(REPO_PATH), $(WORKDIR_DEPS)/$(REPO_NAME))
