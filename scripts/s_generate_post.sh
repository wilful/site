#!/bin/bash
: ${1?"Not enough parameters. Usage: $SCRIPTNAME NameOfFile"}

DATE=`date +%F`
DOMAIN="srv-nix.com"
DIR="/usr/local/www/${DOMAIN}/"
JABBER_DIR="/usr/local/www/jabber.${DOMAIN}/"
FILENAME="${DIR}/_drafts/$DATE-$1.markdown"
JABBER_FILENAME="${JABBER_DIR}/_posts/$DATE-$1.markdown"
PUBLISH_DATE=`date +'%F %T %z'`

if [[ ! -e $FILENAME ]]; then
cat > $FILENAME <<EOF
---
title: "$1"
published: true
layout: post
date: $PUBLISH_DATE
comments: true
categories: linux
author: A. Semenov
tags: 
    - default
---
<!--more-->
EOF
fi

vim $FILENAME
{
    cd $DIR &&
        jekyll build
}

