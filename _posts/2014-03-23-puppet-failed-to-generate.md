---
title: "Puppet. Ошибка верификации ключа шифрования. Failed to generate additional resources using 'eval_generate'...."
published: true
layout: post
date: 2014-03-23 09:00:00 +0000
categories: linux
author: A. Semenov
tags: 
    - linux
    - puppet
---
Проблема возникла на одной из нод puppet после смены hostname и генерации нового сертификата SSL.

<!--more-->

{% highlight ruby  %}
warning: peer certificate won't be verified in this SSL session
info: Caching certificate for node01.wilful.org
info: Retrieving plugin
info: Caching certificate_revocation_list for ca
err: /File[/var/lib/puppet/lib]: Failed to generate additional resources using 'eval_generate': SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: ce
rtificate verify failed
err: /File[/var/lib/puppet/lib]: Could not evaluate: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed Could not retrieve 
file metadata for puppet://service.site.ru/plugins: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
info: Loading facts in iptables
info: Loading facts in iptables
err: Could not retrieve catalog from remote server: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
warning: Not using cache on failed catalog
err: Could not retrieve catalog; skipping run
err: Could not send report: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
{% endhighlight %}

Перед тем, как рвать волосы и удалять сертификаты/перезапускать сервисы/проклинать ruby, нужно проверить или настроить время на сервере. Например так
Теперь удаляем все ранее сгенерированые сертификаты

{% highlight ruby  %}
rm -rf /var/lib/puppet/ssl/
{% endhighlight %}

Тоже самое на сервере для этой ноды
{% highlight ruby  %}
puppet cert clean node01
{% endhighlight %}
Генерируем новый сертификат
{% highlight ruby  %}
puppetd --verbose --test --onetime 
{% endhighlight %}
или
{% highlight ruby  %}
puppet agent --test 
{% endhighlight %}
Подписываем сертификат на сервере
{% highlight ruby  %}
puppet cert sign node01
{% endhighlight %}
Проверяем результат на ноде
{% highlight ruby  %}
puppet agent --test 
{% endhighlight %}

