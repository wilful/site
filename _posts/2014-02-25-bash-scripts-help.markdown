---
title: "Скрипты на все случаи жизни"
published: true
layout: post
date: 2014-02-25 11:52:31 +0600
categories: linux
author: A. Semenov
tags: 
    - help
    - howto
    - bash
---

Хотел просто сделать коллекцию скриптов, которые приходится писать довольно часто, а получился модульный фреймворк для работы с любыми скриптами. В базовый функционал вынесены только функции для работы с логированием, навешиванием lock-файла при необходимости, почтовые рассылки, функции для работы с выводом и прочее.

<!--more-->

Сам фреймворк можно найти [тут][link01].

Как это работает

Для работы скрипта необходимо скопировать (или слинковать) файл конфигурации:
{% highlight bash %}
ln -s ${script_root}/usr/share/rc.conf.example ${script_root}/etc/rc.conf
{% endhighlight %}
После чего можно запустить скрипт без параметров:
{% highlight bash %}
$ bash ${script_root}/bin/wilshell.sh 
==[ Debug inf. ]==  
    2012-11-28_02-44 [LogLevel set 1] [Usage simple]
==[ Usage ]==   
    lock     ==> Module to lock the script
    cleaner  ==> The module for cleaning old files
    backup   ==> Backup files and directories
    mysql    ==> Create a backup of the database
    dumpsys  ==> Dump system state
    sender   ==> Module to send files to a remote server
    iptables     ==> Module to control iptables
    ldap     ==> The backup database server openldap
    rpmbuild     ==> RPM collector packages
    misc     ==> Other Features
{% endhighlight %}

Это не полный список модулей, здесь перечислены модули из массива в файле конфигурации. Полный список модулей можно просмотреть в папке:
{% highlight bash %}
ls -l ${script_root}/usr/modules
{% endhighlight %}
Для отображения списка параметров модуля достаточно запустить его без параметров, например:
{% highlight bash %}
$ bash ${script_root}/bin/wilshell.sh backup
==[ Debug inf. ]==  
    2012-11-28_02-48 [LogLevel set 1] [Usage simple]
==[ Usage ]==   
> -b  Путь к директории содержащей бэкапы [/tmp/backup]
> -d  Удалять бэкапы старше чем, указанное количество дней [3]
> -l  Список папок для бэкапа [fileset.conf]
> -c  Директория с файлсетами для бэкапа [../etc/fileset.d/]
> -r  Запустить бэкап
> -v  Режим отладки
{% endhighlight %}

Некоторые модули сейчас нуждаются в рефакторинге, некоторые еще не полностью дописаны, поскольку большое внимание уделялось самому "движку", бОльшая часть функционала которого описана в  отдельной библиотеке.


[link01]: https://github.com/wilful/root-shell
