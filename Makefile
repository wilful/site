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
	$(GIT_CMD) add .
	$(GIT_CMD) ci -a

push:
	git push
