---
layout: post
title: "Best tool for the job..."
slug: best-tool-for-job
date: 2009-07-25
comments: false
---
So I recently moved, and my new place doesn't make internet by wire all that accessible...so now I have a big honkin desktop computer with no internet, but I have a little netbook which has wireless.

Hmmmm...my netbook's main operating system is Archlinux...and Linux is strong in networking...so it should be easy to set it up right?

Right I was!

```
# give my ethernet an IP address and start it
$  ifconfig eth1 192.168.0.1 netmask 255.255.255.0
$  ifconfig eth1 up

# enable packet forwarding and reboot (or modify /proc)
$  set /etc/sysctl.conf to set net.ipv4.ip_forward=1

# set up iptables
$  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

Done!  Now on my desktop I just set it to static IP 192.168.0.2, connected to my gateway 192.168.0.1, and boom, I got internet!

Now I can wait patiently for a wireless adapter to go on sale...
