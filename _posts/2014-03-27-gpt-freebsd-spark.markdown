---
title: "Использование gpart на сервере FreeBSD (Sparc64 Sun v215)"
published: false
layout: post
date: 2014-03-27 00:56:25 +0600
comments: true
categories: freebsd
author: A. Semenov
tags: 
- freebsd
- gpart
- sparc
---
Собственно всё как в мануалах, для разметки используем VTOC8.

<!--more-->

{% highlight bash %}
gpart create -s VTOC8 -f x /dev/xxx
gpart commit
{% endhighlight %}
У меня получилось вот так
{% highlight bash %}
#gpart show
=>        0  143203410  da0  VTOC8  (68G)
          0   10474380    1  freebsd-ufs  (5G)
   10474380   16771860    2  freebsd-swap  (8G)
   27246240  111137670    4  freebsd-ufs  (53G)
  138383910    4674915    5  freebsd-ufs  (2.2G)
  143058825     144585       - free -  (70M)
{% endhighlight %}

