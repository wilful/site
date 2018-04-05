Title: "CentOS. SSSD и OpenLDAP"
Date: 2014-03-21 09:00:00 +0000
Category: linux
Authors: A. Semenov
Tags: linux, openldap, howto, CentOS

В [предыдущем][l01] топике я показал, как можно быстро настроить ваш сервер OpenLDAP на использование TLS соединений, чтобы наши враги не могли получить сведения из трафика между сервером и клиентом. В дополнении хотелось бы продемонстрировать настройку групповых политик доступа на сервер под управлением CentOS 6. В качестве клиента будем использовать демона SSSD, который начиная с 6.4 ветки стал сервисом аутентификации по умолчанию. 

<!--more-->

Я не являюсь специалистом в LDAP и по этому моя конфигурации DIT не была стандартизирована, как хотелось бы, она в целом напоминает [RFC2307bis][RFC01] с небольшими изменениями в группах. Ниже будет понятно в чем отличия, хотя они совершенно не критичные.
Если вы используете сторонние репозитории или свои сборки, то необходимо убедиться, что OpenLDAP собран с поддержкой memberOf. Это необходимо для того, чтобы мы могли с помощью фильтра демона sssd разграничивать доступ на сервер. Сам атрибут является динамическим и создается в момент обновления сведений о пользователях и группах на сервере. 
## Конфигурация сервера:
Чтобы активировать модуль нужно добавить в slapd.conf следующее 
# Загружаем наложение
moduleload      memberof.la 
# После инициализации БД указываем наш оверлей и дополнительные опции (man slapo-memberof)
overlay                 memberof
memberof-group-oc       groupOfUniqueNames
memberof-member-ad      uniqueMember
Замечание: memberof-group-oc и memberof-member-ad я указал именно потому, что конфигурация дерева на сервере у меня отличается от стандартной. По умолчанию наложение использует класс объекта группы groupOfNames и ждет, что участники групп хранятся в атрибуте member.
Вот так выглядит рабочий конфиг на моем тестовом окружении
# cat slapd.conf                                                                                                                                  
include         /etc/openldap/schema/core.schema
include         /etc/openldap/schema/cosine.schema

TLSCertificateFile      /etc/openldap/cacerts/ldapscert.pem
TLSCertificateKeyFile   /etc/openldap/cacerts/keys/ldapskey.pem
TLSCipherSuite TLSv1+RSA:!NULL

moduleload      back_bdb.la
moduleload      memberof.la 

pidfile         /var/run/openldap/slapd.pid
argsfile        /var/run/openldap/slapd.args

database        bdb
suffix          "o=example,c=ru"
rootdn          "cn=root,o=example,c=ru"
rootpw          secret
directory       /var/lib/ldap

overlay                 memberof
memberof-group-oc       groupOfUniqueNames
memberof-member-ad      uniqueMember
У меня сервер уже был заполнен под завязку, по этому для генерации нового атрибута потребовалось перезалить всю базу на сервер.
Делаем дамп текущей рабочей конфигурации
ldapsearch -x -LLL -D 'cn=root,o=example,c=ru' -w secret  -b 'o=example,c=ru' > /tmp/init.ldif
Чистим DIT
service slapd stop
rm -rf /var/lib/ldap/*
service slapd start
Возвращаем все записи на исходную
ldapmodify -a -v -x -D 'cn=root,o=example,c=ru' -w sercret  -f /tmp/init.ldif
После чего проверяем наличие атрибута memberOf
#ldapsearch -x -LL  -b 'o=example,c=ru' '(uid=user)' memberOf
version: 1

dn: cn=NameSecond,ou=Sysadmins,ou=SoftwareDevelopment,ou=IT,ou=Accounts,o=
 example,c=ru
memberOf: cn=groupname,ou=WebApps,ou=Services,o=example,c=ru


Если все прошло успешно, переходим к настройке клиента
## Конфигурация клиента
На стороне клиента нужно добавить фильтр для демона sssd. Делается это добавлением следующих опций в /etc/sssd/sssd.conf
access_provider = ldap
ldap_access_filter = memberOf=cn=usergroup,ou=UnixShell,ou=Services,o=example,c=ru
Тем самым мы сообщаем серверу что нужно пропускать только тех пользователей, у которых доступен атрибут "memberOf" и его значение равно "cn=usergroup..."
Рабочий файл конфигурации у меня получился такой
[domain/default]
ldap_uri = ldaps://ldap.example.ru
ldap_tls_cacertdir = /etc/openldap/cacerts
ldap_id_use_start_tls = True
cache_credentials = False
ldap_search_base = o=example,c=ru
krb5_realm = EXAMPLE.COM
krb5_server = kerberos.example.com
id_provider = ldap
auth_provider = ldap
chpass_provider = ldap
access_provider = ldap
ldap_access_filter = memberOf=cn=usergroup,ou=UnixShell,ou=Services,o=example,c=ru
[sssd]
services = nss, pam
config_file_version = 2
domains = default
[nss]
[pam]
[sudo]
[autofs]
[ssh]
[pac]
Перезапускаем демона
service sssd restart

[l01]: {% post_url 2014-03-21-openldap-tls %}
[RFC01]: http://www.padl.com/~lukeh/rfc2307bis.txt
