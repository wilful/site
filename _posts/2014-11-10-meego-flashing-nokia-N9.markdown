---
title: "Прошивка телефона Nokia N9 на сток в Docker"
published: true
layout: post
date: 2014-11-10 11:44:56 +0600
comments: true
categories: linux
author: A. Semenov
tags: 
- meego
- NokiaN9
- firmware
- hartmattan
tips:
- Отличный телефон
---

Сам по себе процес прошивки телефона на родную систему весьма тривиален, но в связи с тем, что больше не существует команды разработчиков ОС Meego, многие ресурсы, содержащие прошивки и программы, были заброшены. Я хочу восстановить справедливость и создать русскоязычный гайд по полному сбросу прошивки hartmattan на дефолтное состояние со всеми необходимыми ресурсами.

<!--more-->

Во-первых, нам потребуется скачать саму прошивку. Я нашел её на сайте [mrcrab][l00]. В скобках указан ID вашего устройства, и для того, чтобы найти вашу модель, нужно вытащить крышку с сим-картой. На обратной стороне вы найдёте заветные буквы и цифры. В моём случае это модель [RM-696 NDT RUSSIA BLACK 16GB (059J208)][l01]. 

Чтобы прошить телефон используется утилита [flasher][l02] (В ссылке указан DEB пакет, позже я покажу, как его распокавать и запустить бинарник).

Собирать и прошивать мы будем в контейнере [docker][l03], хостовая ОС ArchLinux, в качестве гостя я использовал CentOS (на данный момент ветка el7). В конце статьи я приведу пример готового Dockerfile, а пока, чтобы сохранить историю моих действий, буду производить их непосредственно в гостевой системе последовательно.

Все необходимые пакеты на момент запуска контейнера у нас есть, приступим:

Предположим, что прошивка и flasher будут лежать у нас в родительской системе в папке /tmp/flasher и запускаем контейнер
{% highlight bash %}
docker run -i -t --name flasher --privileged -v /dev/bus/usb:/dev/bus/usb -v /tmp/flasher/:/mnt/flasher centos /bin/bash
{% endhighlight %}
Теперь нужно установить все необходимые пакеты
{% highlight bash %}
yum install -y libusb glibc tar kmod usbutils
{% endhighlight %}
Распаковываем DEB пакет
{% highlight bash %}
cd /mnt/flasher
ar vx flasher_3.12.1_amd64.deb
tar xzvf data.tar.gz
{% endhighlight %}
После чего будет доступен бинарный файл ./usr/bin/flasher 
{% highlight bash %}
# ./usr/bin/flasher  -V
flasher 3.12.1 (Oct  5 2011) Harmattan
WARNING: This tool is intended for professional use only. Using it may result
in permanently damaging your device or losing the warranty.
{% endhighlight %}
На этом установка flasher закончена и можно приступать к прошивке.

Подключите ваш телефон или кирпич, если вас постигла неудача, как меня, к порту USB. В консоли докера запустите следующую команду
{% highlight bash %}
./usr/bin/flasher -i
{% endhighlight %}
И принудительно выключаем телефон по питанию (удержанием кнопки, если кто не знал)

В результате должны увидеть похожую картину
{% highlight bash %}
./usr/bin/flasher  -i 
flasher 3.12.1 (Oct  5 2011) Harmattan
WARNING: This tool is intended for professional use only. Using it may result
in permanently damaging your device or losing the warranty.

Suitable USB interface (bootloader/phonet) not found, waiting...
USB device found at bus 002, device address 033.
Device identifier: 357923045331966 (SN: N/A)
Found device RM-696, hardware revision 1603
NOLO version 2.3.6
Version of 'sw-release': DFL61_HARMATTAN_40.2012.21-3_PR_001
Success
{% endhighlight %}
Настоятельно рекомендую не приступать к следующему шагу, пока не добьётесь результата с командой выше. Это будет показателем того, что устройство корректно определилось и готово принять свежий дамп прошивки.

Как и с командой выше, аналогично запускаем прошивку телефона
{% highlight bash %}
FIRMWARE="DFL61_HARMATTAN_40.2012.21-3_PR_LEGACY_001-OEM1-958_ARM.bin" #тут укажите вашу прошивку
./usr/bin/flasher -F $FIRMWARE -f
{% endhighlight %}
Через некоторое время, если в консоли не будет каких-либо ошибок, телефон отключится, и его можно будет изъять из порта. После включения вы увидите свежую инсталяцию Meego.

Возможные ошибки:
{% highlight bash %}
Error claiming USB interface: Device or resource busy
{% endhighlight %}
Ядро некорректно определило и подключило наш кирпичик. Решение простое: отключить нафиг модули ядра
{% highlight bash %}
rmmmod cdc_phonet phonet
{% endhighlight %}
Или отключить их загрузку в modprobe.d
{% highlight bash %}
#cat /etc/modprobe.d/50-blacklist.conf 
blacklist cdc_phonet
blacklist phonet
{% endhighlight %}

[l00]: http://www.mrcrab.net/nokia/Nokia_N9.html?productID=4823499691&productType=RM-696&releaseID=7048842309&version=40.2012.21.3
[l01]: https://www.dropbox.com/s/vqm3c8g3ngm8unz/DFL61_HARMATTAN_40.2012.21-3_PR_LEGACY_001-OEM1-958_ARM.bin
[l02]: https://www.dropbox.com/s/9yibrqpieqkaly1/flasher_3.12.1_amd64.deb
[l03]: https://www.docker.com/
