# constants
override TEST_MAKEFILE.MK := $(lastword $(MAKEFILE_LIST))

# targets
PHONY: $(TEST_MAKEFILE.MK)
test-makefile: \
		test-install-destdir \
		test-install-bindir \
		test-install-libdir \
		test-install-prefix \
		test-uninstall-destdir \
		test-uninstall-bindir \
		test-uninstall-libdir \
		test-uninstall-prefix \
		test-workdir-root


PHONY: test-install-destdir
test-install-destdir:
	@$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ > /dev/null
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-kill
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-list
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-open
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-start
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-kill
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-list
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-open
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-start
	@printf "\e[1;32mPassed: $(TEST_MAKEFILE.MK)::$@\e[0m\n"


PHONY: test-install-bindir
test-install-bindir:
	@$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ BINDIR=bindir > /dev/null
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-kill
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-list
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-open
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-start
	@test -f $(WORKDIR_TEST)/$@/bindir/vnctools-kill
	@test -f $(WORKDIR_TEST)/$@/bindir/vnctools-list
	@test -f $(WORKDIR_TEST)/$@/bindir/vnctools-open
	@test -f $(WORKDIR_TEST)/$@/bindir/vnctools-start
	@printf "\e[1;32mPassed: $(TEST_MAKEFILE.MK)::$@\e[0m\n"


PHONY: test-install-libdir
test-install-libdir:
	@$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ LIBDIR=libdir > /dev/null
	@test -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-kill
	@test -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-list
	@test -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-open
	@test -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-start
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-kill
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-list
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-open
	@test -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-start
	@printf "\e[1;32mPassed: $(TEST_MAKEFILE.MK)::$@\e[0m\n"


PHONY: test-install-prefix
test-install-prefix:
	@$(MAKE) install DESTDIR=$(WORKDIR_TEST)/$@ PREFIX=prefix > /dev/null
	@test -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-kill
	@test -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-list
	@test -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-open
	@test -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-start
	@test -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-kill
	@test -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-list
	@test -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-open
	@test -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-start
	@printf "\e[1;32mPassed: $(TEST_MAKEFILE.MK)::$@\e[0m\n"


PHONY: test-uninstall-destdir
test-uninstall-destdir: test-install-destdir
	@$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ > /dev/null
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-kill
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-list
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-open
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-start
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-kill
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-list
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-open
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-start
	@printf "\e[1;32mPassed: $(TEST_MAKEFILE.MK)::$@\e[0m\n"


PHONY: test-uninstall-bindir
test-uninstall-bindir: test-install-bindir
	@$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ BINDIR=bindir > /dev/null
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-kill
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-list
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-open
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/lib/vnctools/vnctools-start
	@test ! -f $(WORKDIR_TEST)/$@/bindir/vnctools-kill
	@test ! -f $(WORKDIR_TEST)/$@/bindir/vnctools-list
	@test ! -f $(WORKDIR_TEST)/$@/bindir/vnctools-open
	@test ! -f $(WORKDIR_TEST)/$@/bindir/vnctools-start
	@printf "\e[1;32mPassed: $(TEST_MAKEFILE.MK)::$@\e[0m\n"


PHONY: test-uninstall-libdir
test-uninstall-libdir: test-install-libdir
	@$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ LIBDIR=libdir > /dev/null
	@test ! -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-kill
	@test ! -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-list
	@test ! -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-open
	@test ! -f $(WORKDIR_TEST)/$@/libdir/vnctools/vnctools-start
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-kill
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-list
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-open
	@test ! -f $(WORKDIR_TEST)/$@/$(HOME)/.local/bin/vnctools-start
	@printf "\e[1;32mPassed: $(TEST_MAKEFILE.MK)::$@\e[0m\n"


PHONY: test-uninstall-prefix
test-uninstall-prefix: test-install-prefix
	@$(MAKE) uninstall DESTDIR=$(WORKDIR_TEST)/$@ PREFIX=prefix > /dev/null
	@test ! -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-kill
	@test ! -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-list
	@test ! -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-open
	@test ! -f $(WORKDIR_TEST)/$@/prefix/lib/vnctools/vnctools-start
	@test ! -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-kill
	@test ! -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-list
	@test ! -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-open
	@test ! -f $(WORKDIR_TEST)/$@/prefix/bin/vnctools-start
	@printf "\e[1;32mPassed: $(TEST_MAKEFILE.MK)::$@\e[0m\n"

PHONY: test-workdir-root
test-workdir-root:
	@$(MAKE) all WORKDIR_ROOT=$(WORKDIR_TEST)/$@ > /dev/null
	@test -d $(WORKDIR_TEST)/$@/deps
	@test -d $(WORKDIR_TEST)/$@/build
	@printf "\e[1;32mPassed: $(TEST_MAKEFILE.MK)::$@\e[0m\n"
