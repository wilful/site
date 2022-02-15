#!/usr/bin/make -f
SHELL = /bin/bash
WORK_DIR = $(shell pwd)
THEMES_DIR = $(WORK_DIR)/themes
THEME = $(THEMES_DIR)/aboutwilson
OUT_DIR = $(WORK_DIR)/docs/
CONTENT_DIR = $(WORK_DIR)/src/content
CONFIG = $(WORK_DIR)/src/pelicanconf.py
GIT_CMD = $(shell which git)
tmp_path = $(WORK_DIR)/src/tmp

drafts_path = $(WORK_DIR)/src/drafts
drafts_files := $(shell find $(drafts_path) -name "*.md")

all: build commit push

build: clean
	pelican -s $(CONFIG) $(CONTENT_DIR) -o $(OUT_DIR) -t $(THEME)

commit:
	@$(GIT_CMD) add .
	@$(GIT_CMD) commit -a

push:
	@$(GIT_CMD) push

post:
	bash bin/new_post

clean:
	rm -rf $(OUT_DIR); mkdir -p $(OUT_DIR);

drafts: $(drafts_files)
	@echo -n "$^: "
	@head -1 $^

test:
	rm -rf $(tmp_path); mkdir -p $(tmp_path); touch $(tmp_path)/.gitkeep
	export PELICAN_ENV=testing; \
	pelican -s $(CONFIG) $(drafts_path) -o $(tmp_path) -t $(THEME) --listen -r
