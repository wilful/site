title: "Небольшие изменения в Graphite(graphite.wsgi) при обновлении Django до версии 1.7"
published: true
layout: post
date: 2014-09-26 12:42:31 +0600
comments: true
categories: freebsd
author: A. Semenov
tags: 
- freebsd
- django
- graphite

Запуск SGI для старта веб приложения [Graphite][l01] начинается со скрипта инициализации в дирректории /usr/local/etc/graphite.
Файл называется graphite.wsgi.example и после установки порта [Graphite][l01] необходимо его вручную переименовать и соответственно
при обновлении нужно учитывать, что обновится именно файл .example и все новшества и изменения будут в нём.

<!--more-->

После последнего обновления, graphite-web перестал у меня запускаться вот с такой, примерно, ошибкой:
{% highlight python %}
  File "/usr/local/lib/python2.7/site-packages/django/apps/registry.py", line 131, in check_models_ready
      raise AppRegistryNotReady("Models aren't loaded yet.")
      django.core.exceptions.AppRegistryNotReady: Models aren't loaded yet.
      unable to load app 0 (mountpoint='') (callable not found or import error)
      *** no app loaded. going in full dynamic mode ***
      *** uWSGI is running in multiple interpreter mode ***
{% endhighlight  %}

Причиной тому несколько обновленных строк в упомянутом выше файле, а именно вместо одной строчки:
{% highlight bash %}
import django.core.handlers.wsgi
{% endhighlight  %}
Стало три строчки таких:
{% highlight bash %}
import django
import django.core.handlers.wsgi
django.setup()
{% endhighlight  %}

Добавляем в свою конфигурацию и перезапускаем uwsgi/apache/etc.

[l01]: http://graphite.wikidot.com/
