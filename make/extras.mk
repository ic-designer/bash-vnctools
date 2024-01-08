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
endef

define build-bash-library
	@echo 'Bulding library $@'
	@mkdir -p $(dir $@)
	@cat $^ > $@
endef

define git-clone-shallow
	$(if $(wildcard $2), rm -rf $2)
	@git clone -qv --depth=1 $1 $2 $(if $3, --branch $3)
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
endef

define install-as-executable
	@install -dv $(dir $@)
	@install -Sv $< $@
	test -f $@
	test -x $@
	diff $@ $<
endef

define install-as-link
	@install -dv $(dir $@)
	@ln -sfv $(realpath $<) $@
	test -L $@
	test -f $@
	diff $@ $<
endef


.PRECIOUS: %/.
%/. :
	@mkdir -p $@
