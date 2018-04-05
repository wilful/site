Title: "Установка Redmine в изолированном контейнере LXC"
Date: 2015-03-24 15:44:13 +0300
Category: linux
Authors: A. Semenov
Tags: linux, redmine, LXC, cgroup, centos

[Redmine][l01] - гибкий инструмент позволяющий удобно организовывать проекты и задачи, а также отслеживать ошибки. Написан он на Ruby и использует известный фреймворк [Ruby on Rails][l02]. GNU GPL, Open Source и все дела... (В вики более подробно)


Самой большой проблемой, с которой сталкиваются люди при работе с этим монстром - это множество версионных зависимостей между различными частями системы. Для решения этой проблемы рекомендуется использовать [Bundler][l03] - приложение, которое выполняет установку [gem][l04]-ов и их обновление в соответствии с конфигурацией из Gemfile. Но данный механизм недостаточно прозрачен для администратора, ведь помимо установки гемов необходимо следить и за актуальными версиями самого [Ruby][l05]. Также при установке плагинов зависимости могут изменяться, устанавливаются новые гемы. И так или иначе при работе с [RoR][l02] приложением система обрастает гигабайтами файлов, которые никаким образом не фигурируют в базе данных пакетного менеджера, да и в базе данных самого пользователя такой объем информации держать не стоит.

Чтобы минимизировать вред для вашей системы и упростить процесс обновления, бэкапа, а также разворачивания тестовых окружений я использую контейнеры [LXC][l06]. Сам набор утилит уже умеет создавать "клоны" систем, используя простое копирование или более продвинутые методы типа снапшотов [BTRFS][l07] или [LVM][l08].

## Установка LXC

    yum install lxc lxc-templates libvirt libvirt-python

Теперь запустим libvirtd, это самый простой способ создания внутренней маршрутизируемой сети для наших контейнеров:

    service libvirtd start

По умолчанию, в качестве места установки будет использоваться /var/lib/lxc 
Если необходимо добавить там места или вынести на отдельный диск, раздел или планету, лучше сделать это сейчас.

    VMSNAME=PlzKillMe #Имя контейнера
    TEMPLATE=centos #Шаблон будущей системы
    LXCPATH=/var/lib/lxc #Место хранения образов
    REL=6 #Релиз CentOS
    lxc-create -n $VMSNAME -t $TEMPLATE -P $LXCPATH -- --release=$REL

После того как образ будет готов, вы увидите сообщение, которое будет означать успешную установку:

    The temporary root password is stored in:

        '/var/lib/lxc/PlzKillMe/tmp_root_pass'

    The root password is set up as expired and will require it to be changed
    at first login, which you should do as soon as possible.  If you lose the
    root password or wish to change it without starting the container, you
    can change it from the host by running the following command (which will
    also reset the expired flag):

        chroot /var/lib/lxc/PlzKillMe/rootfs passwd

Можно запустить контейнер:

    lxc-start -d -n $VMSNAME

## Установка Ruby

Через некоторое время после старта узнаём адрес контейнера

    IP=$(lxc-info -n $VMSNAME | grep IP | awk '{print $2}') && echo $IP

И подключаемся к этому контейнеру (пароль в файле, если не меняли)

    ssh root@$IP

"Кристаллики" будем ставить с помощью [rvm][l09]
Устанавливаем нужные пакеты

    yum install which tar

После чего следуем официальной документации (Эти команды могут устареть, сравните с оффдоками)

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    сurl -sSL https://get.rvm.io | bash -s stable
    source /etc/profile.d/rvm.sh

Устанавливаем последний релиз Ruby

    rvm install ruby

Готово!
Проверяем

    ruby -v

## Получение и установка Redmine

    rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    yum install epel-release -y
    yum install wget nginx ImageMagick-devel mysql-server mysql-devel libcurl-devel

Качаем последнюю версию RM по [ссылке][l10]

    cd /opt/
    wget http://www.redmine.org/releases/redmine-3.0.1.tar.gz
    tar xf redmine-3.0.1.tar.gz
    ln -s redmine-3.0.1 redmine
    adduser redmine

Далее следуем официальной документации

    cd /opt/redmine/
    gem install bundler mysql2
    bundle install --without development test

Настройку сервера БД я оставлю на ваше усмотрение, данные остается только прописать в config/database.yml
В этом примере я буду использовать дефолтный сервер CentOS с правами доступа по умолчанию.

    cp config/database.yml.example config/database.yml

    service mysqld start
    mysql -e "create database redmine character set utf8;"
    rake generate_secret_token
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production rake redmine:load_default_data
    chown redmine:nginx -R files/ log/ tmp/ public/plugin_assets

На этом установка и базовая настройка окончена, теперь попробуем запустить сервер:
ruby bin/rails server webrick -e production

Эта строка будет означать успешный запуск:

[2015-03-24 10:50:49] INFO  WEBrick::HTTPServer#start: pid=24657 port=3000

## Установка Nginx с модулем Passenger

Для запуска RoR приложений будем использовать [Passenger][l11]

    gem install passenger
    passenger-install-nginx-module

Настройки компиляции Nginx я оставил по умолчанию, никаких изменений я не делал, да и нет смысла, это же контейнер, который в любой момент может быть удален или создан заново по данному гайду

После сборки готовый к работе Nginx будет находится в /opt/nginx, нам лишь остаётся запускать его системным init скриптом от нашего старого nginx.
Немного подправим файл с настройками /etc/sysconfig/nginx к следующему виду:

    NGINX=/opt/nginx/sbin/nginx
    CONFFILE=/opt/nginx/conf/nginx.conf
    PIDFILE=/opt/nginx/logs/nginx.pid

Попробуем запустить?

    service nginx start

Если всё хорошо, и сервер запустился, то добавляем в конфиг /opt/nginx/conf/nginx.conf следующие настройки:

    passenger_log_level 5;
    passenger_debug_log_file /opt/nginx/logs/passenger.log;
    server {
        listen       80;
        server_name  redmine.myhost.ru;
        client_max_body_size       128m;
        root /opt/redmine/public/;
        passenger_user redmine;
        passenger_group nginx;
        passenger_enabled on;
        passenger_min_instances 1;
    }
    passenger_pre_start http://redmine.myhost.ru/;

!! Отредактируйте опции в соответствии с вашими условиями. !!

Перезапускаем Nginx и получаем на $IP:80 ваш любимый RM. 
У меня всё. Дальше вы настраиваете проксирование трафика с хоста в гостя как вам удобнее (haproxy, nginx и т.п.)
По умолчанию для входа используются admin/admin 

[l01]: https://ru.wikipedia.org/wiki/Redmine
[l02]: https://ru.wikipedia.org/wiki/Ruby_on_Rails
[l03]: http://bundler.io/
[l04]: https://rubygems.org/
[l05]: https://www.ruby-lang.org/ru/
[l06]: https://linuxcontainers.org/
[l07]: https://ru.wikipedia.org/wiki/Btrfs
[l08]: https://ru.wikipedia.org/wiki/LVM
[l09]: https://rvm.io/
[l10]: http://www.redmine.org/projects/redmine/wiki/Download
[l11]: https://www.phusionpassenger.com/documentation/Users%20guide%20Nginx.html
