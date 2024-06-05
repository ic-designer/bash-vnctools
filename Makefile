# Constants
DESTDIR =
PREFIX = $(HOME)/.local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib
WORKDIR_ROOT := $(CURDIR)/.make

#Targets
.PHONY: all
## Builds the executables
all: private_all

.PHONY: check
## Runs all the repository tests
check: private_test

.PHONY: clean
## Deletes all files created by Make
clean: private_clean
	@$(if $(wildcard .waxwing), rm -rfv .waxwing)

.PHONY: install
## Installs libs and bine to $(DESTDIR)/$(LIBDIR)/$(NAME) and $(DESTDIR)/$(BINDIR)
install: private_install

.PHONY: test
## Runs all the repository tests
test: private_test

.PHONY: uninstall
## Uninstalls libs and bins from $(DESTDIR)/$(LIBDIR)/$(NAME) and $(DESTDIR)/$(BINDIR)
uninstall: private_uninstall

# Includes
include make/private.mk
