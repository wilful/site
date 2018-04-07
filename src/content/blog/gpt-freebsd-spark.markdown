Title: "Использование gpart на сервере FreeBSD (Sparc64 Sun v215)"
Date: 2014-03-27 00:56:25 +0600
Category: freebsd
Authors: A. Semenov
Tags: freebsd, gpart, sparc

Собственно всё как в мануалах, для разметки используем VTOC8.

    gpart create -s VTOC8 -f x /dev/xxx
    gpart commit

У меня получилось вот так

    #gpart show
    =>        0  143203410  da0  VTOC8  (68G)
              0   10474380    1  freebsd-ufs  (5G)
       10474380   16771860    2  freebsd-swap  (8G)
       27246240  111137670    4  freebsd-ufs  (53G)
      138383910    4674915    5  freebsd-ufs  (2.2G)
      143058825     144585       - free -  (70M)

