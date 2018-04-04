title: "CentOS. Настройка CoreDump для apache"
published: true
layout: post
date: 2014-03-26 14:24:18 +0600
comments: true
categories: linux
author: A. Semenov
tags: 
- apache
- linux
- core

<!--more-->

Активируем параметр в конфигурации
{% highlight bash %}
CoreDumpDirectory /tmp
{% endhighlight %}
Насколько я понял, фиолетово какое значение выставлять, просто без этой директивы не работает (:
Говорим ядру где будем хранить "корки"
{% highlight bash %}
echo "/var/tmp/httpd-core.%p" > /proc/sys/kernel/core_pattern
{% endhighlight %}
В папке должны быть права для пользователя, от которого запущен apache
Разрешаем создание "корок"
{% highlight bash %}
# cat /etc/security/limits.conf | grep apache
apache           -       core            -1
{% endhighlight %}
Перезапускаем сервер
{% highlight bash %}
service httpd restart
{% endhighlight %}

