#!/bin/bash

diff_files_list=$(git diff --diff-filter=AM --name-only HEAD^^ HEAD)


COMMITS_ARRAY=( $(git rev-list "HEAD^^".."master") )
for c_commit in ${COMMITS_ARRAY[@]}; do
    declare -a FILES
    FILES=$(git show --pretty="format:" --ignore-submodules --name-only --diff-filter=MACR "${c_commit}")
    echo $FILES
done
