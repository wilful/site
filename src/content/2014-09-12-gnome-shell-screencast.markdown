Title: "Не работает screencast в Gnome-Shell 3.6"
Date: 2014-09-12 17:43:31 +0600
Category: linux
Authors: A. Semenov
Tags: gnome, screencast, problem

После обновления [gnome-shell][l01] с версии 3.4 на 3.6 сломался встроеный скринкастер, который по умолчанию запускается комбинацией клавишь ctrl-alt-shift-r.

<!--more-->

Чтобы починить необходимо доустановть пакет
sudo pacman -Sy xdg-user-dirs
Дальше запускаем от своего НЕ root пользователя
xdg-user-dirs-update
Перезапускаем Gnome (alt-f2 r)

[l01]: https://ru.wikipedia.org/wiki/GNOME_Shell
