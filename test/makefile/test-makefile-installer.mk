DESTDIR ?= $(error ERROR: Undefined variable DESTDIR)
PREFIX ?= $(error ERROR: Undefined variable PREFIX)
BINDIR ?= $(error ERROR: Undefined variable BINDIR)
LIBDIR ?= $(error ERROR: Undefined variable LIBDIR)
PKGSUBDIR ?= $(error ERROR: Undefined variable PKGSUBDIR)
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)

test-install-destdir:
	$(call vnctools::test-makefile::install-helper)

test-install-bindir: BINDIR=bindir
test-install-bindir:
	test "$(BINDIR)" = "bindir"
	$(call vnctools::test-makefile::install-helper)

test-install-libdir: LIBDIR=libdir
test-install-libdir:
	test "$(LIBDIR)" = "libdir"
	$(call vnctools::test-makefile::install-helper)

test-install-prefix: PREFIX=prefix
test-install-prefix:
	test "$(PREFIX)" = "prefix"
	$(call vnctools::test-makefile::install-helper)


test-uninstall-destdir:
	$(call vnctools::test-makefile::install-helper)
	$(call vnctools::test-makefile::uninstall-helper)

test-uninstall-bindir: BINDIR=bindir
test-uninstall-bindir:
	test "$(BINDIR)" = "bindir"
	$(call vnctools::test-makefile::install-helper)
	$(call vnctools::test-makefile::uninstall-helper)

test-uninstall-libdir: LIBDIR=libdir
test-uninstall-libdir:
	test "$(LIBDIR)" = "libdir"
	$(call vnctools::test-makefile::install-helper)
	$(call vnctools::test-makefile::uninstall-helper)

test-uninstall-prefix: PREFIX=prefix
test-uninstall-prefix:
	test "$(PREFIX)" = "prefix"
	$(call vnctools::test-makefile::install-helper)
	$(call vnctools::test-makefile::uninstall-helper)


define vnctools::test-makefile::install-helper
	$(call vnctools::test-makefile::generate-installer-helper,install,)
endef

define vnctools::test-makefile::uninstall-helper
	$(call vnctools::test-makefile::generate-installer-helper,uninstall,!)
endef


define vnctools::test-makefile::install-helper
	$(MAKE) install \
			DESTDIR=$(WORKDIR_TEST)/$@ \
			PREFIX=$(PREFIX) \
			LIBDIR=$(LIBDIR) \
			BINDIR=$(BINDIR) \
			WORKDIR_ROOT=$(WORKDIR_TEST)/$@/.make
	$(foreach f,$(VNCTOOL_LIST),\
			test -f $(WORKDIR_TEST)/$@/$(LIBDIR)/$(PKGSUBDIR)/$(f);)
	$(foreach f,$(VNCTOOL_LIST),\
			test -f $(WORKDIR_TEST)/$@/$(BINDIR)/$(f);)
endef

define vnctools::test-makefile::uninstall-helper
	$(MAKE) uninstall \
			DESTDIR=$(WORKDIR_TEST)/$@ \
			PREFIX=$(PREFIX) \
			LIBDIR=$(LIBDIR) \
			BINDIR=$(BINDIR) \
			WORKDIR_ROOT=$(WORKDIR_TEST)/$@/.make
	$(foreach f,$(VNCTOOL_LIST),\
			test ! -f $(WORKDIR_TEST)/$@/$(LIBDIR)/$(PKGSUBDIR)/$(f);)
	$(foreach f,$(VNCTOOL_LIST),\
			test ! -f $(WORKDIR_TEST)/$@/$(BINDIR)/$(f);)
endef
