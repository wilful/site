---
title: "FreeBSD. Munin - мониторинг на коленке"
layout: post
date: 2014-03-20 09:00:00 +0000
comments: true
categories: freebsd
author: A. Semenov
tags: 
    - freebsd
    - munin 
    - howto
---

[Munin][l02] - простое и надежное средство для мониторинга и визуализации "what just happened to kill our performance?" проблем. Сервер представляет собой коллектор, получающий данные с любого устройства или скрипта, будь то SNMP или внешний скрипт. Данные поступают в базу RRD и затем с помощью специального скрипта (/usr/local/bin/munin-cron) визуализируются на красивых графиках.

<!--more-->

![graph][graph_url]

## Установка сервера

{% highlight bash %}
make install -C /usr/ports/sysutils/munin-master
{% endhighlight %}
После установки порта создаётся каталог /usr/local/www/munin/, в котором хранятся графики. Для их отображения потребуется любой веб сервер. Неплохо справляется с этими задачами сервер [Nginx][l01], с минимальной конфигурацией:
{% highlight bash %}
server {
    listen 78.xxx.xxx.xxx:80;

    server_name munin.site.ltd; 

    set $docroot      "/usr/local/www/munin/";

    index   index.html;
    charset utf-8;
    root    $docroot;

    access_log /var/log/nginx/munin.site.ltd-access.log;
    error_log /var/log/nginx/munin.site.ltd-error.log warn;
}
{% endhighlight %}

## Установка клиента

{% highlight bash %}
make install -C /usr/ports/sysutils/munin-node
{% endhighlight %}
Клиент использует "плагины" для получения сведений о сервере и отправляет их в БД munin-master'а. Плагин может быть написан на любом языке, доступном на сервере, а также в каталоге /usr/local/share/munin/plugins/ находятся уже готовые к использованию скрипты для основных служб и подсистем сервера.

Замечание: Если будете использовать плагины nginx_* и mysql_*, то дополнительно нужно установить два порта:

{% highlight bash %}
make install -C databases/p5-DBI
make install -C www/p5-libwww/
{% endhighlight %}

## Пример использования

Для активации плагина необходимо создать символическую ссылку или скопировать скрипт в рабочую директорию ноды
{% highlight bash %}
ln -s /usr/local/share/munin/plugins/nginx_status /usr/local/etc/munin/plugins/
{% endhighlight %}
Далее вносятся дополнительные изменения в параметры передаваемые скрипту, если это необходимо. Для этого используется файл /usr/local/etc/munin/plugin-conf.d/plugins.conf.
Синтаксис примерно такой:
{% highlight bash %}
[nginx*]                                                                                                                                                              
env.url http://localhost:8081/server-status 
{% endhighlight %}
В квадратных скобках содержится имя или regexp, совпадающий с именем файла «плагина», т.е. в данном случае настройки будут применены для всех «плагинов», содержащих в начале своего имени слово «nginx».
{% highlight bash %}
/usr/local/etc/munin/plugins]# ls -l | grep 'nginx*'                                                                                                         
lrwxr-xr-x  1 root  wheel  44 19 мар 14:03 nginx_request -> /usr/local/share/munin/plugins/nginx_request
lrwxr-xr-x  1 root  wheel  43 19 мар 14:03 nginx_status -> /usr/local/share/munin/plugins/nginx_status
{% endhighlight %}
Параметр env.url указывает URL-адрес для «плагина», с которого нужно считывать сведения о сервере Nginx.
Более детально о параметрах, а так же о правилах использования, можно прочитать в заголовках всех доступных из порта плагинов. Пример для nginx_status:
{% highlight perl %}
#!/usr/local/bin/perl -w                                                                                                                                                
# -*- cperl -*-                                                                                                                                                         
                                                                                                                                                                        
=head1 NAME                                                                                                                                                             
                                                                                                                                                                        
nginx_status - Munin plugin to show connection status for nginx                                                                                                         
                                                                                                                                                                        
=head1 APPLICABLE SYSTEMS                                                                                                                                               
                                                                                                                                                                        
Any nginx host                                                                                                                                                          
                                                                                                                                                                        
=head1 CONFIGURATION                                                                                                                                                    
                                                                                                                                                                        
This shows the default configuration of this plugin.  You can override                                                                                                  
the status URL.                                                                                                                                                         
                                                                                                                                                                        
  [nginx*]                                                                                                                                                              
      env.url http://localhost/nginx_status                                                                                                                             
                                                                                                                                                                        
Nginx must also be configured.  Firstly the stub-status module must be                                                                                                  
compiled, and secondly it must be configured like this:                                                                                                                 
                                                                                                                                                                        
  server {                                                                                                                                                              
        listen 127.0.0.1;                                                                                                                                               
        server_name localhost;                                                                                                                                          
        location /nginx_status {                                                                                                                                        
                stub_status on;                                                                                                                                         
                access_log   off;                                                                                                                                       
                allow 127.0.0.1;                                                                                                                                        
                deny all;                                                                                                                                               
        }                                                                                                                                                               
  }                                                                                                                                                                     
                                                                                                                                                                        
=head1 MAGIC MARKERS                                                                                                                                                    
                                                                                                                                                                        
  #%# family=auto                                                                                                                                                       
  #%# capabilities=autoconf   
                                                                                                                                          
=head1 VERSION                                                                                                                                                          
                                                                                                                                                                        
  $Id$                                                                                                                                                                  
                                                                                                                                                                        
=head1 BUGS                                                                                                                                                             
                                                                                                                                                                        
None known                                                                                                                                                              
                                                                                                                                                                        
=head1 AUTHOR                                                                                                                                                           
                                                                                                                                                                        
Unknown                                                                                                                                                                 
                                                                                                                                                                        
=head1 LICENSE                                                                                                                                                          
                                                                                                                                                                        
Unknown.  Not specified by the unknown author.  Nginx has a BSD                                                                                                         
license.  Munin is GPLv2 licensed.                                                                                                                                      
                                                                                                                                                                        
=cut
{% endhighlight %}
После всех необходимых операций запускаем демона
{% highlight bash %}
echo 'munin_node_enable="YES"' >> /etc/rc.conf 
service munin-node start
{% endhighlight %}

Для генерации HTML-страниц с графиками запускаем вручную
{% highlight bash %}
sudo -u munin /usr/local/bin/munin-cron
{% endhighlight %}
И проверяем наличие этой команды в crontab
{% highlight bash %}
# sudo -u munin crontab -l                                                                                                                        
#BEGIN_MUNIN_MAIN
MAILTO=root

*/5 * * * *     /usr/local/bin/munin-cron
#END_MUNIN_MAIN
{% endhighlight %}

[graph_url]: {{ site.static }}/ef6961.png 

[l01]: http://nginx.org/ru/
[l02]: http://munin-monitoring.org/
[l03]: https://www.freebsd.org/ru/
