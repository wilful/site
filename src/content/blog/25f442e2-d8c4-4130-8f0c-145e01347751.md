Title: "Puppet dashboard [pending tasks] - накопил уже мужик!"
Date: 2014-03-25 18:16:25 +0600
Category: linux
Authors: A. Semenov
Tags: puppet, linux, error

Puppet Dashboard состоит из двух частей - это собственно рельсовый веб движок (puppet-dashboard для CentOS) и демон собирающий статистику puppet-dashboard-worker. Со вторым у меня получилась неприятная ситуация: он просто перестал обрабатывать поступающие запросы на обновление данных. Как выяснилось позже - это происходило из-за одного проблемного запроса, который не позволял демону пройти до конца очереди. На тот момент очередь уже состояла из более чем 6000 запросов.

Итак, диагностика проблемы

* На вебинтерфейсе скапливаются запросы "pending tasks"
* Статус серверов стал "Unresponsive"
* Ощущение, что что-то не так...

Логи для коллектора репортов находятся в /usr/share/puppet-dashboard-worker/log. Мне удалось разглядеть в них ошибку содержащую примерно такой текст:

    ActiveRecord::StatementInvalid: Mysql::Error: Data too long for column 'details' at row 1: INSERT INTO `delayed_job_failures`

Запрос который необходимо было выполнить превышал допустимый размер в поле таблицы. Для исправления воспользовался следующим запросом:

    ALTER TABLE REPORT_LOGS CHANGE COLUMN MESSAGE MESSAGE VARCHAR(65536);

Для чистоты эксперимента я почистил всю очередь запросов:

    service puppet-dashboard-workers stop
    cd /usr/share/puppet-dashboard
    rm -f spool/*
    rake jobs:clear RAILS_ENV=production
    service puppet-dashboard-workers start
