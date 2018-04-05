Title: "webalizer, простейшая статистика для сайта"
Date: 2014-03-23 09:00:00 +0000
Category: linux
Authors: A. Semenov
Tags: web, webalizer, nginx

Пример программы для анализа логов nginx/apache на вашем сервере. Входит в репозитории всех известных мне дистрибутивов GNU\Linux. Утилита webalizer принимает в качестве параметра логи веб-сервера в формате combined и на выхлопе получает HTML с Блэк Джеком и картинками.

В простейшей конфигурации вот так выглядит сервер на nginx, который будем использовать для просмотра нашей статистики

    server {
        listen ${IP}:80;

        server_name webalizer.site.ru;

        set $docroot      "/var/www/webalizer.site.ru";

        index   index.html;
        charset utf-8;
        root    $docroot;

        access_log /var/log/nginx/webalizer.site.ru-access.log;
        error_log /var/log/nginx/webalizer.site.ru-error.log warn;

        location ~* \.(ico|jpg|gif|png|htm|jpeg|swf|txt|avi|wmv|7z|tmp)$ {
            root $docroot;
            access_log off;
        }

        allow 79.140.xxx.xxx;
        deny  all;
    }

Устанавливаем webalizer

    apt-get update && apt-get install webalizer
    OR
    yum install webalizer
    OR
    pacman -Sy webalizer
    OR
    etc...

В cron добавляем с нужной переодичностью

    00  00  *   *   *    webalizer -o /var/www/webalizer.site.ru/ /var/log/nginx/site.ru-access.log

Не забываем указывать свои пути и файлы с логами.
/var/www/webalizer.site.ru/ - папка с отчетами webalizer'а
/var/log/nginx/site.ru-access.log - combined access лог для моего сервера
