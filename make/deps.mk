# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

BASHARGS_VERSION := 0.3.1
BOXERBIRD_BRANCH := main
WAXWING_BRANCH := main

# Dependencies
override BOXERBIRD.MK := $(WORKDIR_DEPS)/make-boxerbird/boxerbird.mk
$(BOXERBIRD.MK):
	@echo "Loading Boxerbird..."
	git clone --config advice.detachedHead=false --depth 1 \
			https://github.com/ic-designer/make-boxerbird.git --branch $(BOXERBIRD_BRANCH) \
			$(WORKDIR_DEPS)/make-boxerbird
	@echo

override BASHARGS_REPO := $(WORKDIR_DEPS)/bash-bashargs-$(BASHARGS_VERSION)
$(BASHARGS_REPO):
	@echo "Loading bashargs..."
	mkdir -p $(WORKDIR_DEPS)
	curl -sL https://github.com/ic-designer/bash-bashargs/archive/refs/tags/$(BASHARGS_VERSION).tar.gz | tar xz -C $(WORKDIR_DEPS)
	test -d $@
	@echo

override WAXWING := $(WORKDIR_DEPS)/bash-waxwing/bin/waxwing
$(WAXWING):
	@echo "Loading Waxwing..."
	git clone  --config advice.detachedHead=false --depth 1 \
			https://github.com/ic-designer/bash-waxwing.git --branch $(WAXWING_BRANCH) \
			$(WORKDIR_DEPS)/bash-waxwing
	@echo
