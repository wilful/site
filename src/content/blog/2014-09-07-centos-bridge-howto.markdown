Title: "Настройка bridge-интерфейса в CentOS"
Date: 2014-09-07 20:10:02 +0600
Category: linux
Authors: A. Semenov
Tags: centos, bridge

    yum install bridge-utils

    # cat /etc/sysconfig/network-scripts/ifcfg-bridge0
    DEVICE="bridge0" 
    TYPE=Bridge
    BOOTPROTO="static" 
    IPADDR="xxx.xxx.xxx.xxx" 
    GATEWAY="xxx.xxx.xxx.xxx" 
    DNS1="xxx.xxx.xxx.xxx"
    ONBOOT="yes" 
    IPV6INIT="no" 
    PEERDNS="yes"

    # cat /etc/sysconfig/network-scripts/ifcfg-eth0 
    DEVICE=eth0
    BOOTPROTO="static" 
    BRIDGE="bridge0" 
    ONBOOT=yes
    Собственно всё
