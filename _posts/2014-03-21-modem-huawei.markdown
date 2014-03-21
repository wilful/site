---
title: "Linux. 3G modem Huawei [E171]"
layout: post
date: 2014-03-21 09:00:00 +0000
categories: linux
author: A. Semenov
tags: 
    - linux
    - modem 
    - 3g
---

В моем распоряжении был модем 3G от провайдера Beeline. В качестве хоста - ArchLinux на моём ноуте. Я не использую NM из идеологических соображений, фронтенд для wvdial - потому что хотелось наглядного представления времени сессии.

Всё просто.
Во-первых, нужно переключить его в режим модема. 
Подключаем модем и смотрим его заводские маркеры:
{% highlight bash %}
#lsusb
Bus 002 Device 009: ID 12d1:1446 Huawei Technologies Co., BLA-BLA-BLA
{% endhighlight %}

12d1:1446 - Это как раз нужные нам значения.
Я заранее побеспокоился и установил необходимые пакеты, это 
{% highlight bash %}
local/usb_modeswitch 1.2.5-2
    Activating switchable USB devices on Linux.
local/gnome-ppp 0.3.23-8
    A GNOME 2 WvDial frontend
{% endhighlight %}

В пакет usb_modeswitch входят наборы пресетов для переключения девайса в режим модема, они находятся в папке /usr/share/usb_modeswitch/[МАРКЕР из lsusb]
Для включения модема вводим команду:
{% highlight bash %}
usb_modeswitch  -v 0x12d1 -p 0x1446 -c /usr/share/usb_modeswitch/12d1\:1446
{% endhighlight %}
И снова проверяем вывод lsusb:
{% highlight bash %}
#lsusb
Bus 002 Device 009: ID 12d1:1436 Huawei Technologies Co., BLA-BLA-BLA
{% endhighlight %}

Как видно из примера, значения изменились, что свидетельствует об успешном переключении устройства. Также должно было появиться устройство вида:
{% highlight bash %}
/dev/ttyUSB[0-9+]
{% endhighlight %}

Теперь можно запустить gnome-ppp, указать настройки и подключиться к сети.
Настройки для Beeline
Логин  beeline
Пароль beeline
Номер  *99#

