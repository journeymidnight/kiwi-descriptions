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
echo "enable ntpd"
systemctl enable ntpd
echo "disble firewalld"
systemctl disable firewalld
echo "disable selinux(after reboot)"
sed -ibak "s/^SELINUX=.*$/SELINUX=disabled/g" /etc/selinux/config

echo "configure tidb"
deploy_user=tidb
echo "Configuration system and user limitation"
LIMITS_CONF="/etc/security/limits.conf"
echo "$deploy_user        soft        nofile        1000000" >> $LIMITS_CONF
echo "$deploy_user        hard        nofile        1000000" >> $LIMITS_CONF
echo "$deploy_user        soft        core          unlimited" >> $LIMITS_CONF
echo "$deploy_user        soft        stack         10240" >> $LIMITS_CONF
mv /binaries/tidb-v1.0.6-linux-amd64/bin/ /home/tidb/deploy
mkdir -p /home/tidb/deploy/log
chown tidb:tidb /home/tidb/deploy/log -R
mkdir -p /home/tidb/deploy/status
chown tidb:tidb /home/tidb/deploy/status -R

#======================================
# Setup default target, multi-user
#--------------------------------------
baseSetRunlevel 3

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

exit 0
