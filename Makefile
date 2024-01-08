# Config
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --no-builtin-rules

# Constants
DESTDIR =
PREFIX = $(HOME)/.local
BINDIR = $(PREFIX)/bin
LIBDIR = $(PREFIX)/lib

override NAME := vnctools
override VERSION := $(shell git describe --always --dirty --broken)
override WORKDIR_ROOT := $(CURDIR)/.make

#Targets
.PHONY: all
all: private_all

.PHONY: check
check: private_test

.PHONY: clean
clean: private_clean

.PHONY: install
install: private_install

.PHONY: test
test: private_test

.PHONY: uninstall
uninstall: private_uninstall


# Includes
include make/private.mk
