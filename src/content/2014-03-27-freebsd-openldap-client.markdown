Title: "Установка и настройка OpenLDAP клиента на сервер FreeBSD (Sparc64 Sun v215)"
Date: 2014-03-27 00:32:20 +0600
Category: freebsd
Authors: A. Semenov
Tags: freebsd, openldap

Чего меньше всего ожидаешь, работая системным администратором? Правильно! Того, что после первой установки придется еще 3 раза разворачивать FreeBSD на Sun v215 5-6 летней давности, удалённо, без доступа к KVM. Поэтому оставлю тут куски трудов для памятки. 

<!--more-->

Для подключения к OpenLDAP серверу нам нужны следующие порты: security/pam_mkhomedir security/pam_ldap net/nss_ldap
make install clean -C /usr/ports/security/pam_mkhomedir
make install clean -C /usr/ports/security/pam_ldap
При сборке ядра я отключил поддержку WITHOUT_KERBEROS=yes, по-этому 
для сборки net/nss_ldap порта FreeBSD под архитектуру sparc64 нужно исходники пропатчить
cp -R /usr/ports/net/nss_ldap/ /usr/local/src/nss_ldap/
Сам патч выглядит так:
cat /root/nss.patch
diff -u -r /usr/ports/net/nss_ldap/Makefile /usr/local/src/nss_ldap/Makefile
+++ /home/bakhtin/work/nss_ldap/Makefile    2009-04-03 20:01:18.000000000 +0400
@@ -33,8 +33,7 @@
 CONFIGURE_ARGS=  --with-ldap-conf-file=${PREFIX}/etc/nss_ldap.conf \
            --with-ldap-secret-file=${PREFIX}/etc/nss_ldap.secret \
                --enable-rfc2307bis \
-         --enable-paged-results \
-              --enable-configurable-krb5-ccname-env
+         --enable-paged-results 
 
 MAN5=        nss_ldap.5
 
diff -u -r /usr/ports/net/nss_ldap/files/patch-ldap-nss.c  /usr/local/src/nss_ldap/files/patch-ldap-nss.c
+++ /home/bakhtin/work/nss_ldap/files/patch-ldap-nss.c      2009-04-03 20:00:30.000000000 +0400
@@ -9,3 +9,11 @@
  #include 
  #elif defined(HAVE_SASL_H)
  #include 
+@@ -84,7 +84,7 @@
+ #include 
+ #include 
+ #endif
+-#ifdef CONFIGURE_KRB5_CCNAME
++#if defined(CONFIGURE_KRB5_CCNAME) && defined(HAVE_KRB5_H)
+ #include 
+ #endif
Зашиваем "заплатку"
patch < /root/nss.patch
И наконец, собираем и устанавливаем порт
make install clean -C /usr/local/src/nss_ldap
Правим файл конфигурации /usr/local/etc/nss_ldap.conf
Сам файл достаточно хорошо документирован, так же есть информация в [handbook][l01] [ещё][l02]
vim /usr/local/etc/nss_ldap.conf
Приведу примеры основных директив
base o=,c=ru
uri ldap://ldap..ru/
pam_groupdn cn=,ou=,ou=,o=,c=ru
pam_member_attribute uniqueMember
pam_password md5
sudoers_base ou=sudoers,ou=,ou=,o=,c=ru
sudoers_debug 0
На всякий случай создаю симлинк для файла конфигурации, некоторые приложения ищут его именно по этому пути
ln -s /usr/local/etc/nss_ldap.conf /usr/local/etc/ldap.conf
Настраиваем сервис pam для подключения  к SSH серверу
vim /etc/pam.d/sshd
Добавим в файл следующие строки
auth        sufficient  /usr/local/lib/pam_ldap.so no_warn
account     sufficient  /usr/local/lib/pam_ldap.so debug
session     sufficient  /usr/local/lib/pam_ldap.so
session     required    /usr/local/lib/pam_mkhomedir.so  debug umask=0077 skel=/usr/local/share/skel
password    required    /usr/local/lib/pam_ldap.so  no_warn try_first_pass

Заставляем систему использовать все наши настройки
vim /etc/nsswitch.conf
Замечание: Настройки связанные с sudoers необходимы только если на сервере LDAP есть схема с настройками sudoers
group: files cache ldap
passwd: files cache ldap
sudoers: ldap
ЗКЩААШЕ?

[l01]: http://www.freebsd.org/doc/en/articles/ldap-auth/client.html
[l02]: http://www.freebsd.org/doc/ru/books/handbook/
