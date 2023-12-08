DESTDIR:=~/.local/
VERSION:=0.1.0

.DELETE_ON_ERROR:
.PHONY: install
install: \
		$(DESTDIR)/lib/vnctools/vnctools-$(VERSION)/vnctools-kill-$(VERSION) \
		$(DESTDIR)/lib/vnctools/vnctools-$(VERSION)/vnctools-list-$(VERSION) \
		$(DESTDIR)/lib/vnctools/vnctools-$(VERSION)/vnctools-open-$(VERSION) \
		$(DESTDIR)/lib/vnctools/vnctools-$(VERSION)/vnctools-start-$(VERSION) \
		$(DESTDIR)/bin/vnctools-kill \
		$(DESTDIR)/bin/vnctools-list \
		$(DESTDIR)/bin/vnctools-open \
		$(DESTDIR)/bin/vnctools-start \

.PHONY: uninstall
uninstall:
	-\rm -fv $(DESTDIR)/lib/vnctools/vnctools-$(VERSION)/*
	-\rm -dv $(DESTDIR)/lib/vnctools/vnctools-$(VERSION)
	-\rm -dv $(DESTDIR)/lib/vnctools
	-\rm -dv $(DESTDIR)/lib
	-\rm -v $(DESTDIR)/bin/vnctools-*
	-\rm -dv $(DESTDIR)/bin
	-\rm -dv $(DESTDIR)


DIR_BUILD:=.make
DIR_SRC:=src
DIR_DEPS:=$(DIR_BUILD)/deps

define bash-merge =
	echo '#!/usr/bin/env bash' > $@
	cat $^ >> $@
	# echo '(' >> $@
	echo '    set -euo pipefail' >> $@
	echo '    main "$$@"' >> $@
	# echo ')' >> $@
endef


$(DESTDIR)/bin/vnctools-% : \
		$(DESTDIR)/lib/vnctools/vnctools-$(VERSION)/vnctools-%-$(VERSION)
	install -dv $(dir $@)
	ln -sfrTv $< $@

$(DESTDIR)/lib/vnctools/vnctools-$(VERSION)/vnctools-%-$(VERSION) : \
		$(DIR_BUILD)/vnctools-%-$(VERSION)
	install -dv $(dir $@)
	install -Tv -m 544 $< $@

$(DIR_BUILD)/vnctools-%-$(VERSION) : \
		$(DIR_SRC)/vnctools/vnctools-%.sh \
		$(DIR_DEPS)/bash-bashargs/src/bashargs/bashargs.sh \
		| $(DIR_BUILD)/
	@$(bash-merge)

$(DIR_DEPS)/bash-bashargs/src/bashargs/bashargs.sh: | $(DIR_DEPS)/
	rm -rf $(DIR_DEPS)/bash-bashargs
	git clone git@github.com:jfredenburg/bash-bashargs.git $(DIR_DEPS)/bash-bashargs

%/ :
	mkdir -p $@

clean:
	rm -rf $(DIR_BUILD)
