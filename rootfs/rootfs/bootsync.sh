#!/bin/sh

/usr/bin/sethostname boot2docker

if grep -q '^docker:' /etc/passwd; then
  # if we have the docker user, let's create the docker group
  /bin/addgroup -S docker
  # ... and add our docker user to it!
  /bin/addgroup docker docker
fi

# Load TCE extensions
/etc/rc.d/tce-loader

# Automount a hard drive
/etc/rc.d/automount

# Configure SSHD
/etc/rc.d/sshd

ip="$(ifconfig | grep -v 'eth0:' | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
baseip=`echo $ip | cut -d"." -f1-3`
dgw=$baseip".1"

/sbin/route add -host $dgw eth0
/sbin/route add default gw $dgw eth0

/bin/echo "nameserver 4.4.4.4" >> /etc/resolv.conf
/bin/echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Launch Docker
/etc/rc.d/docker

/opt/bootlocal.sh &
