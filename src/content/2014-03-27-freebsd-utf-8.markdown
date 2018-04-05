Title: "UTF-8, cyrillic console. Русификация и UTFитизация консоли FreeBSD"
Date: 2014-03-27 00:49:19 +0600
Category: freebsd
Authors: A. Semenov
Tags: freebsd, utf8

Правим файл /etc/login.conf

    russian|Russian Users Accounts:\
    :charset=UTF-8:\
    :lang=ru_RU.UTF-8:\
    :tc=default:

Применяем изменения

    cap_mkdb /etc/login.conf

Устанавливаем язык по умолчанию для нужных пользователей

    pw usermod -n ${username} -L russian
    reboot

