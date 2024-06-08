test-install-destdir:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ 2>/dev/null
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-kill
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-list
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-open
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-start
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-kill
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-list
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-open
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-start

test-install-bindir:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ BINDIR=bindir
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-kill
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-list
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-open
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-start
	test -f $(WORKDIR_TEST)/$@/bindir/vnctools-kill
	test -f $(WORKDIR_TEST)/$@/bindir/vnctools-list
	test -f $(WORKDIR_TEST)/$@/bindir/vnctools-open
	test -f $(WORKDIR_TEST)/$@/bindir/vnctools-start

test-install-libdir:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ LIBDIR=libdir
	test -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-kill
	test -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-list
	test -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-open
	test -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-start
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-kill
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-list
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-open
	test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-start

test-install-prefix:
	$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ PREFIX=prefix
	test -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-kill
	test -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-list
	test -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-open
	test -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-start
	test -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-kill
	test -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-list
	test -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-open
	test -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-start

test-uninstall-destdir: test-install-destdir
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-kill
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-list
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-open
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-start
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-kill
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-list
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-open
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-start

test-uninstall-bindir: test-install-bindir
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ BINDIR=bindir
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-kill
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-list
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-open
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-start
	test ! -f $(WORKDIR_TEST)/$@/bindir/vnctools-kill
	test ! -f $(WORKDIR_TEST)/$@/bindir/vnctools-list
	test ! -f $(WORKDIR_TEST)/$@/bindir/vnctools-open
	test ! -f $(WORKDIR_TEST)/$@/bindir/vnctools-start

test-uninstall-libdir: test-install-libdir
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ LIBDIR=libdir
	test ! -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-kill
	test ! -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-list
	test ! -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-open
	test ! -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-start
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-kill
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-list
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-open
	test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-start

test-uninstall-prefix: test-install-prefix
	$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ PREFIX=prefix
	test ! -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-kill
	test ! -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-list
	test ! -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-open
	test ! -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-start
	test ! -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-kill
	test ! -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-list
	test ! -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-open
	test ! -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-start

test-workdir-root:
	$(MAKE) all WORKDIR_ROOT=$(WORKDIR_TEST)/$@ 2>/dev/null
	test -d $(WORKDIR_TEST)/$@/deps
	test -d $(WORKDIR_TEST)/$@/build
