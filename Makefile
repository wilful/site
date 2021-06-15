#!/usr/bin/make -f
SHELL = /bin/bash
WORK_DIR = $(shell pwd)
THEMES_DIR = $(WORK_DIR)/themes
THEME = $(THEMES_DIR)/aboutwilson
OUT_DIR = $(WORK_DIR)/docs/
CONTENT_DIR = $(WORK_DIR)/src/content
CONFIG = $(WORK_DIR)/src/pelicanconf.py
GIT_CMD = $(shell which git)

all: build commit push

build:
	pelican -s $(CONFIG) $(CONTENT_DIR) -o $(OUT_DIR) -t $(THEME)

commit:
ifeq ($(MESSAGE),)
	@echo "Enter commit message: "; \
    read MESSAGE;
endif
	@git add .; \
    git ci -m '$$(MESSAGE)'

push:
	git push
