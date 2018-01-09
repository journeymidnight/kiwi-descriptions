
# Prepare
1.  Install kiwi-ng: `zypper in python3-kiwi`, patch the following patch:
    1.  0001-skip-make-cache-in-order-to-work-with-fake-repo-in-s.patch: fix bug when access repo in s3. s3 url could not access through port 443.
    2.  0002-output-log-to-serial.patch: for debug.
2.  Clone configuration file: "https://github.com/journeymidnight/kiwi-descriptions.git", branch: "ceph_deploy"

# Build
bash ./build.sh
build result:
> ls ~/works/software/kiwi/Ceph-CentOS-07.0.x86_64-0.4.0*
$user/works/software/kiwi/Ceph-CentOS-07.0.x86_64-0.4.0.install.iso  $user/works/software/kiwi/Ceph-CentOS-07.0.x86_64-0.4.0.raw
$user/works/software/kiwi/Ceph-CentOS-07.0.x86_64-0.4.0.packages     $user/works/software/kiwi/Ceph-CentOS-07.0.x86_64-0.4.0.verified

*.install.iso could install from cdrom
*.raw is an expandable disk image which could dd to disk directly.

# Install
Import from virt-manager.

# Smoke test
[root@bogon ~]# ping -c 4 10.71.84.1
PING 10.71.84.1 (10.71.84.1) 56(84) bytes of data.
64 bytes from 10.71.84.1: icmp_seq=1 ttl=252 time=2.10 ms
64 bytes from 10.71.84.1: icmp_seq=2 ttl=252 time=1.78 ms
64 bytes from 10.71.84.1: icmp_seq=3 ttl=252 time=1.76 ms
64 bytes from 10.71.84.1: icmp_seq=4 ttl=252 time=1.83 ms

--- 10.71.84.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 1.767/1.871/2.100/0.144 ms
[root@bogon ~]# df -h | grep "\/$"
/dev/mapper/systemVG-LVRoot   31G  1.5G   29G   5% /
[root@bogon ~]# df -h | grep "\/var$"
/dev/mapper/systemVG-var      50G  161M   50G   1% /var
[root@bogon ~]# rpm -qa | grep ceph
ceph-mds-12.2.1-0.el7.x86_64
ceph-deploy-1.5.39-0.noarch
libcephfs2-12.2.1-0.el7.x86_64
python-cephfs-12.2.1-0.el7.x86_64
ceph-common-12.2.1-0.el7.x86_64
ceph-selinux-12.2.1-0.el7.x86_64
ceph-osd-12.2.1-0.el7.x86_64
ceph-mon-12.2.1-0.el7.x86_64
ceph-12.2.1-0.el7.x86_64
samba-vfs-cephfs-4.6.2-999.el7.centos.x86_64
ceph_exporter-1.1.0-1.el7.centos.x86_64
ceph-base-12.2.1-0.el7.x86_64
ceph-mgr-12.2.1-0.el7.x86_64
[root@bogon ~]# rpm -qa | grep samba
samba-client-libs-4.6.2-999.el7.centos.x86_64
samba-4.6.2-999.el7.centos.x86_64
samba-vfs-cephfs-4.6.2-999.el7.centos.x86_64
samba-common-libs-4.6.2-999.el7.centos.x86_64
samba-common-tools-4.6.2-999.el7.centos.x86_64
samba-client-4.6.2-999.el7.centos.x86_64
samba-common-4.6.2-999.el7.centos.noarch
samba-libs-4.6.2-999.el7.centos.x86_64
[root@bogon ~]# rpm -qa | grep prome
prometheus-2.0.0-1.el7.centos.x86_64
[root@bogon ~]# rpm -qa | grep exporter
ceph_exporter-1.1.0-1.el7.centos.x86_64
node-exporter-0.15.1-1.el7.centos.x86_64
[root@bogon /]# ls /binaries/
storedeployer_v1.0.tar.gz  tidb-latest-linux-amd64.sha256  tidb-latest-linux-amd64.tar.gz

