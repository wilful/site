---
title: "Не работает screencast в Gnome-Shell 3.6"
published: true
layout: post
date: 2014-09-12 17:43:31 +0600
comments: true
categories: linux
author: A. Semenov
tags: 
- gnome
- screencast
- problem
---

После обновления [gnome-shell][l01] с версии 3.4 на 3.6 сломался встроеный скринкастер, который по умолчанию запускается комбинацией клавишь ctrl-alt-shift-r.

<!--more-->

Чтобы починить необходимо доустановть пакет
{% highlight bash %}
sudo pacman -Sy xdg-user-dirs
{% endhighlight %}
Дальше запускаем от своего НЕ root пользователя
{% highlight bash %}
xdg-user-dirs-update
{% endhighlight %}
Перезапускаем Gnome (alt-f2 r)

[l01]: https://ru.wikipedia.org/wiki/GNOME_Shell
