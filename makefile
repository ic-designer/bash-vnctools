.SUFFIXES:
.DELETE_ON_ERROR:

DESTDIR:=~/.local
VERSION:=0.1.0

PKGSUBDIR:=lib/vnctools/vnctools-$(VERSION)


.PHONY: install
install: \
		$(DESTDIR)/$(PKGSUBDIR)/vnctools-kill-$(VERSION) \
		$(DESTDIR)/$(PKGSUBDIR)/vnctools-list-$(VERSION) \
		$(DESTDIR)/$(PKGSUBDIR)/vnctools-open-$(VERSION) \
		$(DESTDIR)/$(PKGSUBDIR)/vnctools-start-$(VERSION) \
		$(DESTDIR)/bin/vnctools-kill \
		$(DESTDIR)/bin/vnctools-list \
		$(DESTDIR)/bin/vnctools-open \
		$(DESTDIR)/bin/vnctools-start \

.PHONY: uninstall
uninstall:
	-\rm -fv $(DESTDIR)/$(PKGSUBDIR)/*
	-\rm -dv $(DESTDIR)/$(PKGSUBDIR)
	-\rm -dv $(DESTDIR)/lib/vnctools
	-\rm -dv $(DESTDIR)/lib
	-\rm -v $(DESTDIR)/bin/vnctools-*
	-\rm -dv $(DESTDIR)/bin
	-\rm -dv $(DESTDIR)



DIR_BUILD=.make
DIR_BUILD_DEPS:=$(DIR_BUILD)/deps
DIR_BUILD_DIST:=$(DIR_BUILD)/dist
DIR_BUILD_TEST:=$(DIR_BUILD)/test

define build-bash-executable
	echo "bulding executable $@"
	echo '#!/usr/bin/env bash' > $@
	cat $^ >> $@
	echo '(' >> $@
	echo '    set -euo pipefail' >> $@
	echo '    main "$$@"' >> $@
	echo ')' >> $@
endef

define build-bash-library
	echo "building library $@"
	cat $^ >> $@
endef



.PHONY: dist
dist: \
		$(DIR_BUILD_DIST)/$(PKGSUBDIR)/vnctools-kill-$(VERSION) \
		$(DIR_BUILD_DIST)/$(PKGSUBDIR)/vnctools-list-$(VERSION) \
		$(DIR_BUILD_DIST)/$(PKGSUBDIR)/vnctools-open-$(VERSION) \
		$(DIR_BUILD_DIST)/$(PKGSUBDIR)/vnctools-start-$(VERSION)

$(DIR_BUILD_DIST)/$(PKGSUBDIR)/vnctools-%-$(VERSION) : \
		$(DIR_BUILD)/vnctools-%-$(VERSION).merged.sh \
		| $(DIR_BUILD_DIST)/$(PKGSUBDIR)/.
	@$(build-bash-executable)

$(DIR_BUILD)/vnctools-%-$(VERSION).merged.sh : \
		src/vnctools/vnctools-%.sh \
		$(DIR_BUILD_DEPS)/bash-bashargs/src/bashargs/bashargs.sh \
		| $(DIR_BUILD)/.
	@$(build-bash-library)

$(DIR_BUILD_DEPS)/bash-bashargs/src/bashargs/bashargs.sh: | $(DIR_BUILD_DEPS)/.
	@rm -rf $(DIR_BUILD_DEPS)/bash-bashargs
	git clone git@github.com:jfredenburg/bash-bashargs.git $(DIR_BUILD_DEPS)/bash-bashargs


$(DESTDIR)/bin/vnctools-% : \
		$(DESTDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION)
	install -dv $(dir $@)
	ln -sfhv $(realpath $<) $@

$(DESTDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION) : \
		$(DIR_BUILD_DIST)/$(PKGSUBDIR)/vnctools-%-$(VERSION)
	install -dv $(dir $@)
	install -v -m 544 $< $(dir $@)


.PHONY: test
test : \
		$(DIR_BUILD_DEPS)/waxwing/bin/waxwing \
		$(DIR_BUILD_TEST)/test-vnctools-kill.merged.sh \
		$(DIR_BUILD_TEST)/test-vnctools-list.merged.sh \
		$(DIR_BUILD_TEST)/test-vnctools-open.merged.sh \
		$(DIR_BUILD_TEST)/test-vnctools-start.merged.sh
	$(DIR_BUILD_DEPS)/waxwing/bin/waxwing $(DIR_BUILD_TEST)

$(DIR_BUILD_DEPS)/waxwing/bin/waxwing: |$(DIR_BUILD_DEPS)/.
	@rm -rf $(DIR_BUILD_DEPS)/waxwing
	git clone git@github.com:jfredenburg/waxwing.git $(DIR_BUILD_DEPS)/waxwing

$(DIR_BUILD_TEST)/test-vnctools-%.merged.sh : \
		test/vnctools/test-vnctools-%.sh \
 		$(DIR_BUILD)/vnctools-%-$(VERSION).merged.sh \
		| $(DIR_BUILD_TEST)/.
	$(build-bash-library)



clean:
	rm -rf $(DIR_BUILD)

.PRECIOUS: %/.
%/.:
	-@mkdir -p $@
