---
title: "Настройка сервера и клиента OpenLDAP на использование TLS/SSL соединений под CentOS 6"
published: true
layout: post
date: 2014-03-21 09:00:00 +0000
categories: linux
author: A. Semenov
tags: 
    - linux
    - openldap
    - TLS
---

Я не буду вникать в детали генерации сертификатов, не буду детально рассказывать про параметры в конфигурационных файлах. Эта заметка предназначена для быстрой настройки подключения и демонстрации того, что можно использовать стандартные средства консоли без рукоблудства в конфигах. 
Во-первых, нужно сгенерировать свой сертификат и подписать с помощью него клиентский ключ.
Во-вторых, добавить сертификаты в основную конфигурацию slapd и размножить на клиентских машинах с помощью authconfig и любого веб-сервера.
На клиентах будет использоваться демон sssd, который позволяет службам обращаться не напрямую к серверу, а через демона. Тем самым обеспечивается быстродействие при использовании кэша и возможность автономной работы.

Настройка сервера
И так, переходим в каталог в котором будут храниться наши сертификаты:
{% highlight bash %}
cd /etc/openldap/cacerts/
{% endhighlight  %}
И генерируем сертификат
{% highlight bash %}
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout keys/ldapskey.pem -out ldapscert.pem
{% endhighlight  %}
Замечание: в поле hostname нужно вводить реальное имя сервера OpenLDAP, по которому будет доступен сервер
Ключ ldapscert.pem необходимо разместить на веб-сервере, доступ к которому будут иметь все клиентские машины, например так: http://key.server.ltd/ldapscert.pem
Для надежности задаем права доступа только для пользователя ldap
{% highlight bash %}
chown -R ldap:ldap /etc/openldap/cacerts/*
chmod 0400 /etc/openldap/cacerts/keys/ldapskey.pem
{% endhighlight  %}
Вносим изменения для демона slapd (я всё еще использую устаревший метод правки конфигурации через /etc/openldap/slapd.conf)
{% highlight bash %}
---
TLSCertificateFile      /etc/openldap/cacerts/ldapscert.pem
TLSCertificateKeyFile   /etc/openldap/cacerts/keys/ldapskey.pem
TLSCipherSuite TLSv1+RSA:!NULL
---
{% endhighlight  %}
Следующим шагом указываем серверу слушать только ldaps порт, и принимать соединения только через него.
Для этого используется файл /etc/sysconfig/ldap
{% highlight bash %}
---
#   yes/no, default: yes
SLAPD_LDAP=no

# Run slapd with -h "... ldapi:/// ..."
#   yes/no, default: yes
SLAPD_LDAPI=no

# Run slapd with -h "... ldaps:/// ..."
#   yes/no, default: no
SLAPD_LDAPS=yes
---
{% endhighlight  %}
Перезапускаем сервер
{% highlight bash %}
/etc/init.d/slapd stop
rm -rf /etc/openldap/slapd.d/*
sudo -u ldap slaptest -f slapd.conf -F slapd.d/
/etc/init.d/slapd restart
{% endhighlight  %}
Замечание: slaptest я запускаю для того, чтобы новая форма конфигурации так же была актуальной.
На этом настройка сервера закончена. Дополнительно нужно проверить доступность сервера по 636 порту.
Настройка клиента
Для конфигурации клиента будем использовать утилиту authconfig
{% highlight bash %}

SERVER="ldaps://ldap.server.ltd" # Сервер для подключения и он же hostname при генерации сертификата
ROOTDN="o=server,c=ltd" # Корневая запись
CERTURL="http://key.server.ltd/ldapscert.pem" # Адрес веб-сервера на котором лежит наш подписанный клиентский ключик
authconfig --ldapserver=$SERVER --ldapbasedn=$ROOTDN --ldaploadcacert=$CERTURL --enablemkhomedir --updateall --enablesssd --enablesssdauth --enableldap --enableldapauth --disablenis --disablekrb5 --enableldaptls --enableldapstarttls
{% endhighlight  %}
Настройка клиента окончена, можно проверить соединение с помощью

{% highlight bash %}
id user_name
ldapsearch -v -x -b $ROOTDN
ldapsearch -d 1 -v -H ldaps://$SERVER
{% endhighlight  %}

