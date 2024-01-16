# Error Checking
BINDIR ?= $(error ERROR: Undefined variable BINDIR)
WAXWING ?= $(error ERROR: Undefined variable WAXWING)
WORKDIR_TEST ?= $(error ERROR: Undefined variable WORKDIR_TEST)

# Targets
.PHONY: test-vnctools
test-vnctools : $(WAXWING)
	@$(MAKE) install DESTDIR=$(abspath $(WORKDIR_TEST))
	@PATH=$(abspath $(WORKDIR_TEST)/$(BINDIR)):${PATH} $(WAXWING) test/vnctools
