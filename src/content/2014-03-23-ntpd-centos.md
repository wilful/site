Title: "Простейшая настройка сервера NTPD на CentOS 6"
Date: 2014-03-23 09:00:00 +0000
Category: linux
Authors: A. Semenov
Tags: linux, ntpd

<!--more-->
yum install -y ntp
service ntpd restart
chkconfig ntpd on
После чего ждем правки времени
date
Не знаю, как вызвать принудительно, в Debian достаточно было вызвать ntpdate

Делается почти так же, до запуска демона ntpd
ntpdate pool.ntp.org
