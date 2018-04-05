Title: "Генерация нового токена для TeamSpeak3"
Date: 2015-04-29 19:52:16 +0300
Category: linux
Authors: A. Semenov
Tags: FreeBSD, Linux, TeamSpeak, Admin

Запускаем с нужным паролем:

/path/to/bin/teamspeak <any parameters> serveradmin_password=secret

<!--more-->

Подключаемся:

telnet 127.0.0.1 10011

Фигачим:

login serveradmin secret
use 1
tokenadd tokentype=0 tokenid1=6 tokenid2=0

