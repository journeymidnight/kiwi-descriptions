#!/bin/bash
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Mount system filesystems
#--------------------------------------
baseMount

#======================================
# Activate services
#--------------------------------------
#...
systemctl enable ntpd
systemctl stop firewalld
deploy_user=tidb
echo "Configuration system and user limitation"
sysctl -w net.core.somaxconn=32768
sysctl -w vm.swappiness=0
sysctl -w net.ipv4.tcp_syncookies=0
sysctl -w fs.file-max=1000000
LIMITS_CONF="/etc/security/limits.conf"
echo "$deploy_user        soft        nofile        1000000" >> $LIMITS_CONF
echo "$deploy_user        hard        nofile        1000000" >> $LIMITS_CONF
echo "$deploy_user        soft        core          unlimited"
>> $LIMITS_CONF
echo "$deploy_user        soft        stack         10240" >> $
LIMITS_CONF

#======================================
# Setup default target, multi-user
#--------------------------------------
baseSetRunlevel 3

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
