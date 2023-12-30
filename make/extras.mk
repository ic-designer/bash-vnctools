define build-merged-script
	@echo "Bulding merged script $@"
	@cat $^ > $@
endef


define git-clone-shallow
	$(if $(wildcard $2), rm -rf $2)
	@git clone --depth=1 $1 $2 $(if $3, --branch $3)
endef


define git-list-remotes
	@for d in $(1)/*; do \
		echo "$${d} $$(git -C $${d} remote get-url origin --push)"; \
	done
endef


.PRECIOUS: %/.
%/. :
	@mkdir -p $@
