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

if [[ ! -e $JABBER_FILENAME ]]; then
cat > $JABBER_FILENAME <<EOF
---
`cat $FILENAME | grep -E '^title:'`
published: true
layout: chat
date: $PUBLISH_DATE
comments: true
`cat $FILENAME | grep -E '^categories:'`
room: `echo $RANDOM`@conference.jabber.srv-nix.com
---
<!--more-->
EOF
fi
{
    cd $JABBER_DIR &&
        jekyll build
    cd $DIR &&
        jekyll build
}

