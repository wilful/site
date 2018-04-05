Title: "Установка и настройка Graphite WebApp через RPM"
Date: 2015-03-05 11:39:53 +0300
Category: linux
Authors: A. Semenov
Tags: centos, linux, graphite, rpmdev

Хочется поделиться старой, но от этого не менее [хорошей и полезной заметкой][l02], автор которой рассказывает, как можно установить [Graphite][l01] в дистрибутиве CentOS, используя для этого штатные rpm-tools.

<!--more-->

Статья замечательна еще тем, что по сути в радиусе досигаемости гугла (менее 5 страницы поиска) она единственная.

И я, к сожалению, не нашел в [официальной документации][l01] раздела, в котором была бы описана данная процедура. Но она есть! И на момент написания этого поста отлично работает!

Как я уже говорил, статья не блещет новизной, и поэтому будем считать этот пост свободным переводом оригинальной статьи автора с дополнениями и правками от меня.

Первым делом ставим все необходимые для сборки пакеты:

    yum install -y gcc zlib-devel curl curl-devel openssl rpm-build gcc-c++ rpm-build python python-ldap python-memcached python-sqlite2 pycairo python-twisted Django django-tagging bitmap bitmap-fonts python-devel glibc-devel gcc-c++ openssl-devel python-zope-interface httpd memcached mod_wsgi rpmdevtools

!! Важно заметить: я выполняю все операции в изолированном контейнере LXC, по-этому я не парюсь с пользователями. Если у вас нет такой возможности, то необходимо подготовить окружение такое, как я писал раннее в [статье о сборке Nginx][l03] !!

После установки приложений, я создаю дерево сборки от текущего пользователя и меняю текущий каталог:

    rpmdev-setuptree
    SOURCE_DIR="~/rpmbuild/SOURCES/"
    cd $SOURCE_DIR

Далее необходимо получить свежие исходные коды Graphite, Carbon и Whisper:

    git clone https://github.com/graphite-project/graphite-web
    git clone https://github.com/graphite-project/carbon
    git clone https://github.com/graphite-project/whisper

В отличие от автора, я использую git репозитории, мне кажется, что такой способ установки и обновления более нагляден и удобен.

Теперь переключим наши репозитории на нужные стабильные ветки (список доступных можно узнать командой 'git tag'):

    STABLE='0.9.12'
    cd graphite-web
    git checkout tags/$STABLE

Теперь можно приступить к сборке SOURCE RPM. 

    WHISPER_DIR="$SOURCE_DIR/whisper"
    CARBON_DIR="$SOURCE_DIR/carbon"
    GRAPHITE_DIR="$SOURCE_DIR/graphite-web"
    pushd $WHISPER_DIR
    python setup.py bdist_rpm
    rpm -ivh dist/whisper-*.src.rpm
    pushd $CARBON_DIR
    python setup.py bdist_rpm
    rpm -ivh dist/carbon-*.src.rpm
    pushd $GRAPHITE_DIR
    python setup.py bdist_rpm
    rpm -ivh dist/graphite-web-$STABLE*.src.rpm

В результате выполнения команд мы получим src.rpm пакеты. В конце сборки каждого пакета вывод должен быть примерно таким:
                     ---
    Executing(--clean): /bin/sh -e /var/tmp/rpm-tmp.raj2Ji
    + umask 022
    + cd /root/rpmbuild/SOURCES/graphite-web/build/bdist.linux-x86_64/rpm/BUILD
    + rm -rf graphite-web-0.9.12
    + exit 0
    moving build/bdist.linux-x86_64/rpm/SRPMS/graphite-web-0.9.12-1.src.rpm -> dist
    moving build/bdist.linux-x86_64/rpm/RPMS/noarch/graphite-web-0.9.12-1.noarch.rpm -> dist

В результате в сборочной директории сервера мы получим архивы с исходниками и SPEC файлы:

    ls -l ~/rpmbuild/SPECS
    carbon.spec
    graphite-web.spec
    whisper.spec

Сборка исходных кодов у меня прошла без каких-либо затруднений, выполнял как обычно:

    cd ~/rpmbuild/SPECS
    rpmbuild -ba carbon.spec
    rpmbuild -ba whisper.spec
    rpmbuild -ba graphite-web.spec

Теперь можно установить полученные в ~/rpmbuild/RPMS/ пакеты в систему, устанавливать нужно начиная с Whisper

    yum --nogpgcheck localinstall -y ../RPMS/noarch/whisper*.noarch.rpm
    yum --nogpgcheck localinstall -y ../RPMS/noarch/carbon*.noarch.rpm
    yum --nogpgcheck localinstall -y ../RPMS/noarch/graphite-web*.noarch.rpm

Нет времени дописать статью. Продолжение будет после выхода Half-Life 3...

[l01]: http://graphite.wikidot.com/documentation
[l02]: http://www.rampmeupscotty.com/blog/2012/08/07/installing-graphite-on-centos-6-dot-2/
[l03]: http://srv-nix.com/linux/2014/04/04/build-nginx.html
