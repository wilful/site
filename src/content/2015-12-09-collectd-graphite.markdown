Title: "Установка на CentOS Collectd с плагином для Graphite"
Date: 2015-12-09 11:06:25 +0300
Category: linux
Authors: A. Semenov
Tags: linux, collectd, graphite

Навеяно постом с [хабра][l00].

Начиная с версии 5.1 Collectd имеет возможность использовать Write плагин для записи статистики в time-series базе Carbon.
Который в свою очередь является бакенд стораджем для Graphite. В данной связке можно создавать очень крутые графики или в дальнейшем производить
анализ метрик.

Из обновлений:
`Write Graphite plugin: The new "write_graphite" plugin writes value lists to Carbon, the storage layer of the Graphite time-series database. Thanks to Scott Sanders and Pierre-Yves Ritschard for their work.`

<!--more-->

Но проблема заключается в том, что в стандартных репозиториях CentOS в наличии имеется только версия 4+

По-этой причине я опишу сборку RPM для Collectd. Lанная процедура не сложна, но она никак не указана в документации.

Качаем исходники с https://collectd.org/download.shtml
VERSION=5.5.0
wget https://collectd.org/files/collectd-$VERSION.tar.gz`

В tar:///collectd-$VERSION.tar.gz/contrib/redhat находится SPEC, правим его по необходимости

И собираем нужные rpm. Мне пришлось собирать вот так: 
`QA_RPATHS=$[ 0x0001|0x0010 ] rpmbuild -ba collectd.spec`

В результате получим кучу готовых для установки RPM (сам и его плагины).


[l00]: http://habrahabr.ru/company/ua-hosting/blog/272447/
