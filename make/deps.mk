# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

BASHARGS_VERSION := 0.3.3
BOXERBIRD_BRANCH := main
WAXWING_BRANCH := main

# Dependencies
override BASHARGS_REPO := $(WORKDIR_DEPS)/bash-bashargs-$(BASHARGS_VERSION)
$(BASHARGS_REPO):
	@echo "INFO: Fetching $@..."
	mkdir -p $(WORKDIR_DEPS)
	curl -sL https://github.com/ic-designer/bash-bashargs/archive/refs/tags/$(BASHARGS_VERSION).tar.gz | tar xz -C $(WORKDIR_DEPS)
	test -d $@
	@echo "INFO: Fetching $@ completed."
	@echo

override BOXERBIRD.MK := $(WORKDIR_DEPS)/make-boxerbird/boxerbird.mk
$(BOXERBIRD.MK):
	@echo "INFO: Fetching $@..."
	git clone --config advice.detachedHead=false --depth 1 \
			https://github.com/ic-designer/make-boxerbird.git --branch $(BOXERBIRD_BRANCH) \
			$(WORKDIR_DEPS)/make-boxerbird
	test -f $@
	@echo "INFO: Fetching $@ completed."
	@echo

override WAXWING := $(WORKDIR_DEPS)/bash-waxwing/bin/waxwing
$(WAXWING):
	@echo "INFO: Fetching $@..."
	git clone  --config advice.detachedHead=false --depth 1 \
			https://github.com/ic-designer/bash-waxwing.git --branch $(WAXWING_BRANCH) \
			$(WORKDIR_DEPS)/bash-waxwing
	test -f $@
	@echo "INFO: Fetching $@ completed."
	@echo
