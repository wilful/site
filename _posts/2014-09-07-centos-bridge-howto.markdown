---
title: "Настройка bridge-интерфейса в CentOS"
published: true
layout: post
date: 2014-09-07 20:10:02 +0600
comments: true
categories: linux
author: A. Semenov
tags: 
- centos
- bridge
---
<!--more-->
{% highlight bash %}
yum install bridge-utils
{% endhighlight %}

{% highlight bash %}
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
{% endhighlight %}
{% highlight bash %}
# cat /etc/sysconfig/network-scripts/ifcfg-eth0 
DEVICE=eth0
BOOTPROTO="static" 
BRIDGE="bridge0" 
ONBOOT=yes
{% endhighlight %}
Собственно всё
