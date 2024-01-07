# Constants
DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
NAME ?= $(error ERROR: Undefined variable NAME)
VERSION ?= $(error ERROR: Undefined variable VERSION)
WORKDIR_ROOT ?= $(error ERROR: Undefined variable WORKDIR_ROOT)

override BINSUBDIR = bin
override LIBSUBDIR = lib
override PKGSUBDIR = $(LIBSUBDIR)/$(NAME)/$(NAME)-$(VERSION)
override SRCSUBDIR = src
override WORKDIR = $(WORKDIR_ROOT)/$(NAME)-$(VERSION)
override WORKDIR_BUILD = $(WORKDIR)/build
override WORKDIR_PKGS = $(WORKDIR)/pkgs
override WORKDIR_TEST = $(WORKDIR)/test

# Includes
include make/extras.mk

# Dependencies
WAXWING:=$(WORKDIR_PKGS)/waxwing/bin/waxwing
$(WAXWING): |$(WORKDIR_PKGS)/.
	$(call git-clone-shallow, \
			git@github.com:ic-designer/waxwing.git, \
			$(WORKDIR_PKGS)/waxwing, \
			main)

$(WORKDIR_PKGS)/bash-bashargs/src/bashargs/bashargs.sh: | $(WORKDIR_PKGS)/.
	$(call git-clone-shallow, \
			git@github.com:ic-designer/bash-bashargs.git, \
			$(WORKDIR_PKGS)/bash-bashargs, \
			0.1.1)

# Private targets
.PHONY: private_all
private_all: \
		$(WORKDIR_BUILD)/$(PKGSUBDIR)/vnctools-kill-$(VERSION) \
		$(WORKDIR_BUILD)/$(PKGSUBDIR)/vnctools-list-$(VERSION) \
		$(WORKDIR_BUILD)/$(PKGSUBDIR)/vnctools-open-$(VERSION) \
		$(WORKDIR_BUILD)/$(PKGSUBDIR)/vnctools-start-$(VERSION)
	@for f in $^; do test -f $${f}; done

$(WORKDIR_BUILD)/$(PKGSUBDIR)/vnctools-%-$(VERSION): \
		$(WORKDIR_PKGS)/bash-bashargs/src/bashargs/bashargs.sh \
		src/vnctools/vnctools-%.sh \
		| $(WORKDIR_BUILD)/$(PKGSUBDIR)/.
	$(call build-bash-executable, main) && test -f $@


.PHONY: private_clean
private_clean:
	@echo "Cleaning directories: $(WORKDIR_ROOT), $(WORKDIR), $(WORKDIR_PKGS), $(WORKDIR_TEST)"
	$(if $(wildcard $(WORKDIR)), rm -rf $(WORKDIR))
	$(if $(wildcard $(WORKDIR_PKGS)), rm -rf $(WORKDIR_PKGS))
	$(if $(wildcard $(WORKDIR_ROOT)), rm -rf $(WORKDIR_ROOT))
	$(if $(wildcard $(WORKDIR_TEST)), rm -rf $(WORKDIR_TEST))


.PHONY: private_install
private_install: \
		$(DESTDIR)/$(PKGSUBDIR)/vnctools-kill-$(VERSION) \
		$(DESTDIR)/$(PKGSUBDIR)/vnctools-list-$(VERSION) \
		$(DESTDIR)/$(PKGSUBDIR)/vnctools-open-$(VERSION) \
		$(DESTDIR)/$(PKGSUBDIR)/vnctools-start-$(VERSION) \
		$(DESTDIR)/$(BINSUBDIR)/vnctools-kill \
		$(DESTDIR)/$(BINSUBDIR)/vnctools-list \
		$(DESTDIR)/$(BINSUBDIR)/vnctools-open \
		$(DESTDIR)/$(BINSUBDIR)/vnctools-start

$(DESTDIR)/$(BINSUBDIR)/vnctools-%: $(DESTDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION)
	$(call install-as-link)

$(DESTDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION): $(WORKDIR_BUILD)/$(PKGSUBDIR)/vnctools-%-$(VERSION)
	$(call install-as-executable)


.PHONY: private_pkg_list
private_pkg_list:
	$(call git-list-remotes, $(WORKDIR_PKGS))


.PHONY: private_pkg_override
private_pkg_override: REPO_NAME ?= $(error ERROR: Name not defined. Please defined REPO_NAME=<name>)
private_pkg_override: REPO_PATH ?= $(error ERROR: Repo not defined. Please defined REPO_PATH=<path>)
private_pkg_override:
	$(call git-clone-shallow, $(REPO_PATH), $(WORKDIR_PKGS)/$(REPO_NAME))


.PHONY: private_test
private_test : $(WAXWING)
	@$(MAKE) install DESTDIR=$(abspath $(WORKDIR_TEST))
	@PATH=$(abspath $(WORKDIR_TEST)/$(BINSUBDIR)):${PATH} $(WAXWING) test/vnctools


.PHONY: private_uninstall
private_uninstall:
	@-\rm -rdfv $(DESTDIR)/$(PKGSUBDIR) 2> /dev/null
	@-\rm -dv $(dir $(DESTDIR)/$(PKGSUBDIR)) 2> /dev/null
	@-\rm -dv $(DESTDIR)/$(LIBSUBDIR) 2> /dev/null
	@test ! -e $(DESTDIR)/$(PKGSUBDIR)

	@-\rm -v $(DESTDIR)/$(BINSUBDIR)/vnctools-*
	@-\rm -dv $(DESTDIR)/$(BINSUBDIR)
	@-\rm -dv $(DESTDIR)




# .PHONY: private_clean
# private_clean:
# 	@echo "Cleaning directories: $(WORKDIR), $(WORKDIR_PKGS), $(WORKDIR_TEST)"
# 	$(if $(wildcard $(WORKDIR)), rm -rf $(WORKDIR))
# 	$(if $(wildcard $(WORKDIR_PKGS)), rm -rf $(WORKDIR_PKGS))
# 	$(if $(wildcard $(WORKDIR_TEST)), rm -rf $(WORKDIR_TEST))


# .PHONY: private_pkg_list
# private_pkg_list:
# 	$(call git-list-remotes, $(WORKDIR_PKGS))


# .PHONY: private_pkg_override
# private_pkg_override: REPO ?= $(error ERROR: Repo not defined. Please defined REPO=<repository>)
# private_pkg_override: NAME ?= $(error ERROR: Name not defined. Please defined NAME=<repository>)
# private_pkg_override:
# 	$(call git-clone-shallow, $(REPO), $(WORKDIR_PKGS)/$(NAME))
