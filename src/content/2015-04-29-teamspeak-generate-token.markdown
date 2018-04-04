title: "Генерация нового токена для TeamSpeak3"
published: true
layout: post
date: 2015-04-29 19:52:16 +0300
comments: true
categories: linux
author: A. Semenov
tags: 
- FreeBSD
- Linux
- TeamSpeak
- Admin

Запускаем с нужным паролем:

{% highlight bash %}
/path/to/bin/teamspeak <any parameters> serveradmin_password=secret
{% endhighlight %}

<!--more-->

Подключаемся:

{% highlight bash %}
telnet 127.0.0.1 10011
{% endhighlight %}

Фигачим:

{% highlight bash %}
login serveradmin secret
use 1
tokenadd tokentype=0 tokenid1=6 tokenid2=0
{% endhighlight %}

