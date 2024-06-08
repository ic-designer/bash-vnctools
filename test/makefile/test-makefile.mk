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
	$(call vnctools::test-makefile::install-helper)

test-install-libdir: LIBDIR=libdir
test-install-libdir:
	$(call vnctools::test-makefile::install-helper)

test-install-prefix: PREFIX=prefix
test-install-prefix:
	$(call vnctools::test-makefile::install-helper)


test-uninstall-destdir:
	$(call vnctools::test-makefile::install-helper)
	$(call vnctools::test-makefile::uninstall-helper)

test-uninstall-bindir: BINDIR=bindir
test-uninstall-bindir:
	$(call vnctools::test-makefile::install-helper)
	$(call vnctools::test-makefile::uninstall-helper)

test-uninstall-libdir: LIBDIR=libdir
test-uninstall-libdir:
	$(call vnctools::test-makefile::install-helper)
	$(call vnctools::test-makefile::uninstall-helper)

test-uninstall-prefix: PREFIX=prefix
test-uninstall-prefix:
	$(call vnctools::test-makefile::install-helper)
	$(call vnctools::test-makefile::uninstall-helper)


test-workdir-root:
	$(MAKE) all WORKDIR_ROOT=$(WORKDIR_TEST)/$@ 2>/dev/null
	test -d $(WORKDIR_TEST)/$@/deps
	test -d $(WORKDIR_TEST)/$@/build


define vnctools::test-makefile::install-helper
	$(MAKE) install \
			DESTDIR=$(WORKDIR_TEST)/$@ \
			PREFIX=$(PREFIX) \
			LIBDIR=$(LIBDIR) \
			BINDIR=$(BINDIR) \
			2>/dev/null
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
			2>/dev/null
	$(foreach f,$(VNCTOOL_LIST),\
			test ! -f $(WORKDIR_TEST)/$@/$(LIBDIR)/$(PKGSUBDIR)/$(f);)
	$(foreach f,$(VNCTOOL_LIST),\
			test ! -f $(WORKDIR_TEST)/$@/$(BINDIR)/$(f);)
endef
