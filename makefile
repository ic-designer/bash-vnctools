DESTDIR:=~/.local
override VERSION:=0.1.0+20231228

.PHONY: all
all: private_all

.PHONY: check
check: private_test

.PHONY: clean
clean: private_clean

.PHONY: install
install: private_install

.PHONY: pkg_list
pkg_list: private_pkg_list

.PHONY: pkg_override
pkg_override: private_pkg_override

.PHONY: test
test: private_test

.PHONY: uninstall
uninstall: private_uninstall


# Config
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules


# Paths
override BINSUBDIR:=bin
override LIBSUBDIR:=lib

override WORKDIR:=.make
override WORKDIR_BUILD:=$(WORKDIR)/build
override WORKDIR_PKGS:=$(WORKDIR)/pkgs
override WORKDIR_TEST:=$(WORKDIR)/test

# Includes
include make/private.mk
