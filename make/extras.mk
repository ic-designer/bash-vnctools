define build-bash-executable
	@echo 'Bulding executable $@'
	@mkdir -p $(dir $@)
	@echo '#!/usr/bin/env bash\n' > $@
	@cat $^ >> $@
	@echo >> $@
	@echo 'if [[ $${BASH_SOURCE[0]} == $${0} ]]; then' >> $@
	@echo '    ('  >> $@
	@echo '        set -euo pipefail'  >> $@
	@echo '        $(strip $(1)) "$$@"'  >> $@
    @echo '    )'  >> $@
	@echo 'fi'  >> $@
	@echo
endef

define build-bash-library
	@echo 'Bulding library $@'
	@mkdir -p $(dir $@)
	@cat $^ > $@
	@echo
endef

define git-clone-shallow
	$(if $(wildcard $2), rm -rf $2)
	git clone -v --depth=1 --config advice.detachedHead=false $1 $2 $(if $3, --branch $3)
	@echo
endef

define git-list-remotes
	@for d in $(1)/*; do \
		echo '$${d} $$(git -C $${d} remote get-url origin --push)'; \
	done
endef

define install-as-copy
	@install -dv $(dir $@)
	@install -Sv $< $@
	test -f $@
	diff $@ $<
	@echo
endef

define install-as-executable
	@install -dv $(dir $@)
	@install -Sv -m 544 $< $@
	test -f $@
	test -x $@
	diff $@ $<
	@echo
endef

define install-as-link
	@install -dv $(dir $@)
	@ln -sfv $(realpath $<) $@
	test -L $@
	test -f $@
	diff $@ $<
	@echo
endef


.PRECIOUS: %/.
%/. :
	@install -dv $@
