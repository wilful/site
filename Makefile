#!/usr/bin/make -f
SHELL = /bin/bash
WORK_DIR = $(shell pwd)
THEMES_DIR = $(WORK_DIR)/themes
THEME = $(THEMES_DIR)/aboutwilson
OUT_DIR = $(WORK_DIR)/docs/
CONTENT_DIR = $(WORK_DIR)/src/content
CONFIG = $(WORK_DIR)/src/pelicanconf.py
GIT_CMD = $(shell which git)

drafts_files = $(WORK_DIR)/src/drafts
tmp_folder = $(WORK_DIR)/src/tmp

srcfiles := $(shell find $(drafts_files) -name "*.md")

all: build commit push

build: clean
	pelican -s $(CONFIG) $(CONTENT_DIR) -o $(OUT_DIR) -t $(THEME)

commit:
	@$(GIT_CMD) add .
	@$(GIT_CMD) ci -a

push:
	@$(GIT_CMD) push

post:
	bash bin/new_post

clean:
	rm -rf $(OUT_DIR); mkdir -p $(OUT_DIR);

drafts: $(srcfiles)
	@head -1 $^

test:
	rm -rf $(tmp_folder); mkdir -p $(tmp_folder); touch $(tmp_folder)/.gitkeep
	export PELICAN_ENV=testing; \
	pelican -s $(CONFIG) $(drafts_files) -o $(tmp_folder) -t $(THEME) --listen -r
