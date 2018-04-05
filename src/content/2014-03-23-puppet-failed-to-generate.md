Title: "Puppet. Ошибка верификации ключа шифрования. Failed to generate additional resources using 'eval_generate'...."
Date: 2014-03-23 09:00:00 +0000
Category: linux
Authors: A. Semenov
Tags: linux, puppet

Проблема возникла на одной из нод puppet после смены hostname и генерации нового сертификата SSL.

<!--more-->

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

Перед тем, как рвать волосы и удалять сертификаты/перезапускать сервисы/проклинать ruby, нужно проверить или настроить время на сервере. Например [так][link01]

Теперь удаляем все ранее сгенерированые сертификаты

rm -rf /var/lib/puppet/ssl/

Тоже самое на сервере для этой ноды
puppet cert clean node01
Генерируем новый сертификат
puppetd --verbose --test --onetime 
или
puppet agent --test 
Подписываем сертификат на сервере
puppet cert sign node01
Проверяем результат на ноде
puppet agent --test 


[link01]: {{ site.url }}/linux/2014/03/23/ntpd-centos.html
