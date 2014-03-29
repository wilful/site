#!/bin/bash

DOMAIN="srv-nix.com"
DIR="/usr/local/www/${DOMAIN}/"
JABBER_DIR="/usr/local/www/jabber.${DOMAIN}/"
FILENAME="${DIR}/_posts/`date +%F`-$1.markdown"
JABBER_FILENAME="${JABBER_DIR}/_posts/`date +%F`-$1.markdown"
PUBLISH_DATE=`date +'%F %T %z'`

cd $DIR/_posts/
for i in `ls -1`; do
    if [[ -f $i ]]; then
        if [[ ! -e $JABBER_DIR/$i ]]; then
            cat > $JABBER_DIR/_posts/$i <<-EOF
---
`cat $DIR/_posts/$i | grep -E '^title:'`
published: true
layout: chat
`cat $DIR/_posts/$i | grep -E '^date:'`
`cat $DIR/_posts/$i | grep -E '^categories:'`
room: `echo $RANDOM`@conference.jabber.srv-nix.com
---
<!--more-->
EOF
        fi
    fi
done

