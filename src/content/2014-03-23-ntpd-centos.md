title: "Простейшая настройка сервера NTPD на CentOS 6"
published: true
layout: post
date: 2014-03-23 09:00:00 +0000
comments: true
categories: linux
author: A. Semenov
:tags: linux, ntpd

<!--more-->
{% highlight bash %}
yum install -y ntp
service ntpd restart
chkconfig ntpd on
{% endhighlight %}
После чего ждем правки времени
{% highlight bash %}
date
{% endhighlight %}
Не знаю, как вызвать принудительно, в Debian достаточно было вызвать ntpdate

Делается почти так же, до запуска демона ntpd
{% highlight bash %}
ntpdate pool.ntp.org
{% endhighlight %}
