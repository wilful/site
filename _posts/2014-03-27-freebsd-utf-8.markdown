---
title: "UTF-8, cyrillic console. Русификация и UTFитизация консоли FreeBSD"
published: true
layout: post
date: 2014-03-27 00:49:19 +0600
comments: true
categories: freebsd
author: A. Semenov
tags: 
- freebsd
- utf8
---

<!--more-->

Правим файл /etc/login.conf
{% highlight bash %}
russian|Russian Users Accounts:\
:charset=UTF-8:\
:lang=ru_RU.UTF-8:\
:tc=default:
{% endhighlight %}
Применяем изменения
{% highlight bash %}
cap_mkdb /etc/login.conf
{% endhighlight %}
Устанавливаем язык по умолчанию для нужных пользователей
{% highlight bash %}
pw usermod -n ${username} -L russian
reboot
{% endhighlight %}

