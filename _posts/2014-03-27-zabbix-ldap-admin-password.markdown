---
title: "Zabbix. Сброс пароля администратора и отключение LDAP"
published: true
layout: post
date: 2014-03-27 01:07:19 +0600
categories: linux
author: A. Semenov
tags: 
- linux
- zabbix
- ldap
---

<!--more-->

Подключаемся к БД сервера. 
Меняем пароль
{% highlight mysql %}
UPDATE `zabbix`.`users` SET passwd=md5('mynewpassword') WHERE `alias`='Admin';
{% endhighlight %}
Отключаем LDAP
{% highlight mysql %}
UPDATE  `zabbix`.`config` SET  `authentication_type` =  '0' WHERE  `config`.`configid` =1;
{% endhighlight %}

