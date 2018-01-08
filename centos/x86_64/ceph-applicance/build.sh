#!/bin/bash

cd /home/suse01/works/source/kiwi-descriptions/centos/x86_64/ceph-applicance
#./download.sh
cd rpms
rm repodata -rf
createrepo .
mv ~/works/software/kiwi/build/image-root/var/lib/machines/ ~/works/software/kiwi.machines.old
rm -rf ~/works/software/kiwi/build/image-root/
systemctl restart lvm2-lvmetad.service
kiwi-ng --debug --color-output --type oem system build --description /home/suse01/works/source/kiwi-descriptions/centos/x86_64/ceph-applicance --target-dir ~/works/software/kiwi
