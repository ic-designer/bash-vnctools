# Constants
DESTDIR =
PREFIX = $(HOME)/.local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib
WORKDIR_ROOT := $(CURDIR)/.make

#Targets
.PHONY: all
all: private_all

.PHONY: check
check: private_test

.PHONY: clean
clean: private_clean
	@$(if $(wildcard .waxwing), rm -rfv .waxwing)

.PHONY: install
install: private_install

.PHONY: test
test: private_test

.PHONY: uninstall
uninstall: private_uninstall

# Includes
include make/private.mk
