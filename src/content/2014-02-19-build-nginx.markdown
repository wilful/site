title: "Сборка ПО из SOURCE rpm пакета на сервере CentOS 6 (nginx+LDAP)"
layout: post
date: 2014-04-04 09:01:00 +0000
comments: true
categories: linux
author: A. Semenov
tags: linux, CentOS, nginx, rpmdev, howto
links: habr|http://habrahabr.ru/post/194482/ test|http://test.com

_Правильная_ сборка пакетов на сервере под rpm-based системами. Никаких "make install".  

#### Подготовка сервера к сборке

1\. Для начала нужно установить пакеты:
    ::bash
    yum install -y rpmdevtools gcc make yum-utils sudo tar # Дописать пакеты, необходимые для сборки
{% endhighlight %}
2\. Добавляем в систему пользователя, от которого будет выполняться сборка:
{% highlight bash %}
useradd -m rpmbuild
{% endhighlight %}
3\. Готовим дерево сборки для пакетов:
{% highlight bash %}
sudo -u rpmbuild -i
rpmdev-setuptree
tree -L 1 rpmbuild/
rpmbuild/
├── BUILD # Директория сборки
├── BUILDROOT # Директория сборки
├── RPMS # Содержит готовые rpm-пакеты
├── SOURCES # Исходные коды
├── SPECS # Файлы описаний (SPEC)
└── SRPMS # Исходные srpm-пакеты
{% endhighlight %}

#### Сборка собственного пакета на примере nginx+ldap

**внимание: не выполняй сборку от имени root!!!**

1\. Все операции выполняются от пользователя rpmbuild (чтобы не нанести вред системе)
{% highlight bash %}
sudo -u rpmbuild -i 
{% endhighlight %}
2\. Качаем необходимые исходники/пачи/файлы
    Для nginx я взял SRC пакет из официального 
    [репозитория nginx](http://wiki.nginx.org/Install#Official_Red_Hat.2FCentOS_packages) для CentOS. 
    Модуль для авторизации с официального [репозитория GIT](https://github.com/kvspb/nginx-auth-ldap) 
{% highlight bash %}
cd ~/rpmbuild/SRPMS/
VERSION_NG="1.2.5"
wget -nd -r -l 1 -A "nginx-${VERSION_NG}*src.rpm"  http://nginx.org/packages/centos/6/SRPMS/ 2>/dev/null
cd ~/rpmbuild/SOURCES/
git clone https://github.com/kvspb/nginx-auth-ldap 
{% endhighlight %}
3\. Устанавливаем необходимые для сборки пакеты
{% highlight bash %}
yum-builddep nginx-${VERSION_NG}-*.ngx.src.rpm --nogpgcheck 
{% endhighlight %}
4\. Устанавливаем пакет (он будет распакован в предварительно подготовленное дерево 
    каталогов /home/rpmbuild/rpmbuild)
{% highlight bash %}
rpm -ivh nginx-${VERSION_NG}-*.ngx.src.rpm
{% endhighlight %}
5\. Вносим изменения в файл сборки
{% highlight bash %}
vim ~/rpmbuild/SPECS/nginx.spec
{% endhighlight %}
6\. Меняем в строке номер релиза (чтобы пакет обновился при установке)
{% highlight bash %}
Release: 4%{?dist}.wil
{% endhighlight %}
_ЗАМЕЧАНИЕ:_ Я также указал суффикс wil для уникальности пакета 

7\. Добавляем строку описания источника с исходными текстами модуля
{% highlight bash %}
Source1001: nginx-auth-ldap
{% endhighlight %}
8\. Добавляем модуль в параметры сборки nginx (так же как при обычной сборке)
{% highlight bash %}
./configure \
--add-module=%{SOURCE1001} \
{% endhighlight %}
_ЗАМЕЧАНИЕ:_ Возможно потребуется добавить параметры сборки дважды для debug и original версий пакета 

9\. Теперь можем приступить к сборке нашего пакета
{% highlight bash %}
cd ~/rpmbuild/SPECS/
rpmbuild -bb nginx.spec 
{% endhighlight %}
10\. После сборки будет примерно следующая запись:
{% highlight bash %}
Записан: /home/rpmbuild/rpmbuild/RPMS/x86_64/nginx-1.bla.bla.rpm
Записан: /home/rpmbuild/rpmbuild/RPMS/x86_64/nginx-debug-1.bla.bla.rpm 
{% endhighlight %}
11\. Это наши готовые для установки пакеты, теперь можно установить через rpm или 
     использовать локальный репозиторий для установки через yum
12\. Так же рекомендую создать srpm-пакет, чтобы не потерять ваши изменения и можно было 
     развернуть его на любом сервере
{% highlight bash %}
rpmbuild -bs nginx.spec
{% endhighlight %}
13\. Файл будет тут
{% highlight bash %}
Записан: /home/rpmbuild/rpmbuild/SRPMS/nginx-1.bla.bla.src.rpm
{% endhighlight %}
14\. PROFIT?

[wilful-gh]: https://github.com/wilful
[home]:    http://srv-nix.com
