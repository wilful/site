title: Read from stdin and write to stdout in vim
date: 2020-09-17 22:27:13 +0500
category: linux
authors: Andrey Semenov
tags: vim

For example:

    cat /etc/fstab | vim -

Edit text and send to another server:

    :w !ssh root@server 'cat - > /tmp/fstab'
