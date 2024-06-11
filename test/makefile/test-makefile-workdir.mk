
test-workdir-root:
	$(call vnctools::test-workdir::build-helper)

test-workdir-build: WORKDIR_BUILD=build
test-workdir-build:
	test "$(WORKDIR_BUILD)" = "build"
	$(call vnctools::test-workdir::build-helper)

test-workdir-deps: WORKDIR_DEPS=deps
test-workdir-deps:
	test "$(WORKDIR_DEPS)" = "deps"
	$(call vnctools::test-workdir::build-helper)

define vnctools::test-workdir::build-helper
	$(MAKE) all \
			WORKDIR_ROOT=$(WORKDIR_TEST)/$@ \
			WORKDIR_BUILD=$(WORKDIR_TEST)/$@/$(WORKDIR_BUILD) \
			WORKDIR_DEPS=$(WORKDIR_TEST)/$@/$(WORKDIR_DEPS) \
			2>/dev/null
	test -d $(WORKDIR_TEST)/$@/$(WORKDIR_BUILD)
	test -d $(WORKDIR_TEST)/$@/$(WORKDIR_DEPS)
endef
