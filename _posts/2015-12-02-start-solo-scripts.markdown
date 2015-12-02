---
title: "Запуск скриптов с блокировкой (lock-file)"
published: true
layout: post
date: 2015-12-02 07:07:46 +0300
comments: true
categories: linux
author: A. Semenov
tags: 
- linux
- cron

---

Пример скрипта для запуска скриптов с блокировкой из крона

<!--more-->

{% highlight bash %}
#!/bin/bash

BIN=$(which bash)
SCRIPT=$1
SCRIPT_NAME=$(basename $SCRIPT)
LOCKDIR='/tmp'
STALE_AGE=4 #hours
CMD=${2:-'/usr/bin/php'}
PIDFILE=$LOCKDIR/$SCRIPT_NAME/pid
LOCKFILE=$LOCKDIR/$SCRIPT_NAME/lock
LOGFILE=$LOCKDIR/$SCRIPT_NAME/log

fail() {
    local m=$1

    echo $m 1>&2 &&
        exit 1
}
clean() {
    local f=$1

    rm -rf $f
}

if mkdir $LOCKDIR/$SCRIPT_NAME &> /dev/null; then
    eval "$CMD $SCRIPT &"  2>&1 &>$LOGFILE # || fail "Error while starting script $SCRIPT"
    PID=$!
    echo $!>$PIDFILE
    touch $LOCKFILE
    if wait "$PID"; then
        echo "[$(date +%s)]: Success" &>$LOGFILE
        clean $LOCKDIR/$SCRIPT_NAME
    else
        fail "[$(date +%s)]: Something went wrong, see log: $LOGFILE"
    fi
    exit 0
else
    PID=$(cat $PIDFILE)
    if ! kill -s 0 $PID 2>&1 &>/dev/null; then
        echo "[$(date +%s)]: Process not found, try to restarting $SCRIPT" 1>&2
        clean $LOCKDIR/$SCRIPT_NAME
        $BIN $0 "$SCRIPT" &&
            exit 0
        fail "[$(date +%s)]: Can't to start script $SCRIPT"
    else
        echo "[$(date +%s)]: Process already run with pid $PID" &>>$LOGFILE
    fi
    if [[ $(($(date +%s) - $(stat -c %Y $LOCKFILE) )) -gt $(( $STALE_AGE *60 *60 )) ]]; then
        echo "[$(date +%s)]: File $LOCKFILE staled, try to restart script $SCRIPT" 1>&2
        echo "[$(date +%s)]: killing $PID" 1>&2
        if ! kill -15 $PID &> /dev/null; then
            fail "[$(date +%s)]: Can't killing process with pid $PID"
        fi
        echo "[$(date +%s)]: Removing stale lock folder: $LOCKDIR/$SCRIPT_NAME" 1>&2
        clean $LOCKDIR/$SCRIPT_NAME
        $BIN $0 "$SCRIPT"
    fi
fi
{% endhighlight %}

