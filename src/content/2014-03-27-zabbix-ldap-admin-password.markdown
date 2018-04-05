Title: "Zabbix. Сброс пароля администратора и отключение LDAP"
Date: 2014-03-27 01:07:19 +0600
Category: linux
Authors: A. Semenov
Tags: linux, zabbix, ldap

Простая инструкция на случай, если вы после очередного обновления или по случайности потеряли привилегированный доступ к админке сервера [zabbix][].

<!--more-->

+ Подключаемся к БД сервера. 
+ Меняем пароль
UPDATE `zabbix`.`users` SET passwd=md5('mynewpassword') WHERE `alias`='Admin';
+ Отключаем LDAP
UPDATE  `zabbix`.`config` SET  `authentication_type` =  '0' WHERE  `config`.`configid` =1;

[zabbix]: http://www.zabbix.com/ru/
