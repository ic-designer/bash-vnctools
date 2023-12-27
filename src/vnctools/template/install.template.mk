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


$(DESTDIR)/bin/vnctools-% : $(DESTDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION)
	install -dv $(dir $@)
	ln -sfhv $(realpath $<) $@

$(DESTDIR)/$(PKGSUBDIR)/vnctools-%-$(VERSION) : vnctools-%-$(VERSION)
	install -dv $(dir $@)
	install -v -m 544 $< $(dir $@)
