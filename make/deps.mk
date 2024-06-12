# Constants
WORKDIR_DEPS ?= $(error ERROR: Undefined variable WORKDIR_DEPS)

# Load Bowerbird Dependency Tools
BOWERBIRD_DEPS.MK := $(WORKDIR_DEPS)/bowerbird-deps/bowerbird_deps.mk
$(BOWERBIRD_DEPS.MK):
	@curl --silent --show-error --fail --create-dirs --location -o $@ https://raw.githubusercontent.com/ic-designer/make-bowerbird-deps/main/src/bowerbird-deps/bowerbird-deps.mk
include $(BOWERBIRD_DEPS.MK)

# Bowerbird Compatible Dependencies
$(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-bash-builder,\
		https://github.com/ic-designer/make-bowerbird-bash-builder.git,0.1.0,bowerbird.mk))
$(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-githooks,\
		https://github.com/ic-designer/make-bowerbird-githooks.git,0.1.0,bowerbird.mk))
$(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-help,\
		https://github.com/ic-designer/make-bowerbird-help.git,0.1.0,bowerbird.mk))
$(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-install-tools,\
		https://github.com/ic-designer/make-bowerbird-install-tools.git,0.1.0,bowerbird.mk))
$(eval $(call bowerbird::git-dependency,$(WORKDIR_DEPS)/bowerbird-test,\
		https://github.com/ic-designer/make-bowerbird-test.git,main,bowerbird.mk))


# Other Dependencies
BASHARGS_BRANCH := main
override BASHARGS_REPO = $(WORKDIR_DEPS)/bash-bashargs
override BASHARGS.SH = $(WORKDIR_BUILD)/bashargs/lib/bashargs/bashargs.sh

$(BASHARGS_REPO):
	@echo "INFO: Fetching $@..."
	@git clone  --config advice.detachedHead=false --depth 1 https://github.com/ic-designer/bash-bashargs.git --branch $(BASHARGS_BRANCH) $(BASHARGS_REPO)
	test -d $@
	@echo "INFO: Fetching $@ completed."
	@echo

$(BASHARGS.SH): $(BASHARGS_REPO)
	@echo "Building bashargs..."
	$(MAKE) -C $(BASHARGS_REPO) install \
			DESTDIR=$(WORKDIR_BUILD) LIBDIR=lib WORKDIR_ROOT=$(WORKDIR_ROOT)
	test -f $@
	@echo

$(BASHARGS.MK): $(BASHARGS_REPO) $(BASHARGS.SH)
	echo '# bashargs.mk' > $@
include $(BASHARGS.MK)


WAXWING_BRANCH := main
WAXWING = $(WORKDIR_DEPS)/bash-waxwing/bin/waxwing
$(WAXWING):
	@echo "INFO: Building $@..."
	@git clone  --config advice.detachedHead=false --depth 1 https://github.com/ic-designer/bash-waxwing.git --branch $(WAXWING_BRANCH) $(WORKDIR_DEPS)/bash-waxwing
	@test -f $@
	@echo "INFO: Build $@ complete."
	@echo
