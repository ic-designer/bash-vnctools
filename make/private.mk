# Required Paths
DESTDIR  ?= $(error ERROR: Undefined variable DESTDIR)
VERSION ?= $(error ERROR: Undefined variable VERSION)

BINSUBDIR ?= $(error ERROR: Undefined variable BINSUBDIR)
LIBSUBDIR ?= $(error ERROR: Undefined variable LIBSUBDIR)
WORKDIR ?= $(error ERROR: Undefined variable WORKDIR)
WORKDIR_BUILD ?= $(error ERROR: Undefined variable WORKDIR_BUILD)
WORKDIR_PKGS ?= $(error ERROR: Undefined variable WORKDIR_PKGS)
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)


override PKGSUBDIR:=$(LIBSUBDIR)/vnctools/vnctools-$(VERSION)


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
			main)


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
		src/vnctools/bash/vnctools-%.sh \
		| $(WORKDIR_BUILD)/$(PKGSUBDIR)/.
	$(call build-bash-executable, main) && test -f $@


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


$(DESTDIR)/$(BINSUBDIR)/vnctools-% : $(DESTDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION)
	@install -dv $(dir $@)
	@ln -sfv $(realpath $<) $@
	@test -L $@
	@test -f $@
	@diff $@ $<


$(DESTDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION) : \
		$(WORKDIR_BUILD)/$(PKGSUBDIR)/vnctools-%-$(VERSION).sh
	@install -dv $(dir $@)
	@install -v -m 544 $< $@
	@test -f $@
	@test -x $@
	@diff -c $@ $<


.PHONY: private_uninstall
private_uninstall:
	-\rm -fv $(DESTDIR)/$(PKGSUBDIR)/*
	-\rm -dv $(DESTDIR)/$(PKGSUBDIR)
	-\rm -dv $(dir $(DESTDIR)/$(PKGSUBDIR))
	-\rm -dv $(DESTDIR)/$(LIBSUBDIR)
	-\rm -v $(DESTDIR)/$(BINSUBDIR)/vnctools-*
	-\rm -dv $(DESTDIR)/$(BINSUBDIR)
	-\rm -dv $(DESTDIR)
	test ! -e $(DESTDIR)/$(PKGSUBDIR)


.PHONY: private_test
private_test : \
		$(WAXWING) \
		$(WORKDIR_TEST)/test-vnctools-kill-$(VERSION).merged.sh \
		$(WORKDIR_TEST)/test-vnctools-list-$(VERSION).merged.sh \
		$(WORKDIR_TEST)/test-vnctools-open-$(VERSION).merged.sh \
		$(WORKDIR_TEST)/test-vnctools-start-$(VERSION).merged.sh
	$(WAXWING) $(WORKDIR_TEST)

$(WORKDIR_TEST)/test-vnctools-%-$(VERSION).merged.sh : \
 		$(WORKDIR_BUILD)/$(PKGSUBDIR)/vnctools-%-$(VERSION).sh \
		test/vnctools/test-vnctools-%.sh \
		| $(WORKDIR_TEST)/.
	@$(build-merged-script)


.PHONY: private_clean
private_clean:
	@echo "Cleaning directories: $(WORKDIR), $(WORKDIR_PKGS), $(WORKDIR_TEST)"
	$(if $(wildcard $(WORKDIR)), rm -rf $(WORKDIR))
	$(if $(wildcard $(WORKDIR_PKGS)), rm -rf $(WORKDIR_PKGS))
	$(if $(wildcard $(WORKDIR_TEST)), rm -rf $(WORKDIR_TEST))


.PHONY: private_pkg_list
private_pkg_list:
	$(call git-list-remotes, $(WORKDIR_PKGS))


.PHONY: private_pkg_override
private_pkg_override: REPO ?= $(error ERROR: Repo not defined. Please defined REPO=<repository>)
private_pkg_override: NAME ?= $(error ERROR: Name not defined. Please defined NAME=<repository>)
private_pkg_override:
	$(call git-clone-shallow, $(REPO), $(WORKDIR_PKGS)/$(NAME))
