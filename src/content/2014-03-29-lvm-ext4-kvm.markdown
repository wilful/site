Title: "LVM+KVM+EXT4, изменение размера виртуального диска с собственной таблицей разделов"
Date: 2014-03-29 01:09:27 +0300
Category: linux
Authors: A. Semenov
Tags: linux, lvm, kvm, fs, ext4

Нам понадобятся: lvm2, kpartx, cfdisk, e2fsck

Выключаем VPS на которой используется раздел LVM.
Увеличиваем сам том:

    # lvextend -L +2G /dev/mapper/vms-vps--test

'+2G' - размер на который увеличиваем диск
Теперь открываем раздел и пересоздаём таблицу разделов.

    # cfdisk /dev/mapper/vms-fms--test                                                                                                                   

Чтобы открыть нужные разделы, я воспользовался утилитой kpartx:

    # kpartx -a /dev/mapper/vms-vps--test

После чего в системе появится нужный нам раздел '/dev/mapper/vms-vps--test1'
Проверяем раздел:

    # e2fsck -f /dev/mapper/vms-vps--test1                                                                                                               
    e2fsck 1.41.12 (17-May-2010)
    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    /dev/mapper/vms-fms--test1: 13/576000 files (0.0% non-contiguous), 1889245/2340856 blocks

Обновляем информацию о новом размере ФС:

    # resize2fs -p /dev/mapper/vms-vps--test1                                                                                                            
    resize2fs 1.41.12 (17-May-2010)
    Resizing the filesystem on /dev/mapper/vms-vps--test1 to 2865144 (4k) blocks.
    Begin pass 1 (max = 16)
    Extending the inode table     XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    The filesystem on /dev/mapper/vms-vps--test1 is now 2865144 blocks long.

Отключаем чтение таблицы разделов:

    # kpartx -d /dev/mapper/vms-vps--test

Проверяем результат:

    # lvs

После чего запускаем виртуальную машину, раздел должен быть увеличенным на указанное число.
Всй!
