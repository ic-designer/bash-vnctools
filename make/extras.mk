define build-bash-library
	@echo 'Bulding library $@'
	@cat $^ > $@
endef


define build-bash-executable
	@echo 'Bulding executable $@'
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



define git-clone-shallow
	$(if $(wildcard $2), rm -rf $2)
	@git clone -qv --depth=1 $1 $2 $(if $3, --branch $3)
endef


define git-list-remotes
	@for d in $(1)/*; do \
		echo '$${d} $$(git -C $${d} remote get-url origin --push)'; \
	done
endef


.PRECIOUS: %/.
%/. :
	@mkdir -p $@
