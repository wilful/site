#!/bin/bash
#: ${1?"Not enough parameters. Usage: $SCRIPTNAME NameOfFile"}

echo -n "Введите заголовок статьи:"
read NAME
echo -n "Введите имя автора:"
read AUTHOR
echo -n "Введите теги:"
read TAGS
echo -n "Введите желаемый раздел:"
read CTGRS

DATE=`date +%F`
DIR="$(dirname $(readlink -f $0))/.."
FILENAME="${DIR}/_drafts/$DATE-$1.markdown"
JABBER_FILENAME="${JABBER_DIR}/_posts/$DATE-$1.markdown"
PUBLISH_DATE=`date +'%F %T %z'`

#if [[ ! -e $FILENAME ]]; then
#cat > $FILENAME <<EOF
#---
#title: "$1"
#published: true
#layout: post
#date: $PUBLISH_DATE
#categories: linux
#author: A. Semenov
#tags: 
#    - default
#---
#<!--more-->
#EOF
#fi
#
#vim $FILENAME

