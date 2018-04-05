Title: "CentOS. Настройка CoreDump для apache"
Date: 2014-03-26 14:24:18 +0600
Category: linux
Authors: A. Semenov
Tags: apache, linux, core

<!--more-->

Активируем параметр в конфигурации
CoreDumpDirectory /tmp
Насколько я понял, фиолетово какое значение выставлять, просто без этой директивы не работает (:
Говорим ядру где будем хранить "корки"
echo "/var/tmp/httpd-core.%p" > /proc/sys/kernel/core_pattern
В папке должны быть права для пользователя, от которого запущен apache
Разрешаем создание "корок"
# cat /etc/security/limits.conf | grep apache
apache           -       core            -1
Перезапускаем сервер
service httpd restart

