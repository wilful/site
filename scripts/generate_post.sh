#!/bin/bash
: ${1?"Not enough parameters. Usage: $SCRIPTNAME NameOfFile"}
FILENAME="../_drafts/`date +%F`-$1.markdown"

if [[ ! -e $FILENAME ]]; then
cat > $FILENAME <<EOF
---
title: "$1"
published: false
layout: post
date: `date +'%F %T %z'`
categories: linux
author: A. Semenov
tags: 
    - default
---
<!--more-->
EOF
fi

