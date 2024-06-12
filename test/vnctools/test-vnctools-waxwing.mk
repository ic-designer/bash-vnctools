# Error Checking
BINDIR ?= $(error ERROR: Undefined variable BINDIR)
WAXWING ?= $(error ERROR: Undefined variable WAXWING)
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)

# Targets
test-vnctools-waxwing: $(WAXWING)
	$(MAKE) install \
		DESTDIR=$(abspath $(WORKDIR_TEST)/$@)
		WORKDIR=$(WORKDIR_TEST)/$@/.make
	PATH=$(abspath $(WORKDIR_TEST)/$@/$(BINDIR)):${PATH} $(WAXWING) test/vnctools
