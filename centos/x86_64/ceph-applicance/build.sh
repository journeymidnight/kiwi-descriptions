#!/bin/bash

s3_repo_dir=/var/cache/kiwi/yum/cache/repo_samba
s3_repo_url=http://reposamba.los-cn-north-1.lecloudapis.com

echo "Downloading repo data from fake repo in s3"
mkdir -p $s3_repo_dir
cd $s3_repo_dir
wget $s3_repo_url/repodata/repomd.xml
grep location  repomd.xml  | sed "s/^.*\"\(.*\)\".*$/wget http:\/\/reposamba.los-cn-north-1.lecloudapis.com\/\1/g" > repomd.sh
bash ./repomd.sh
cd ..

echo "Downloading rpm and binaries(skip TiDB as we do not udpate when necessary)"
cd /home/suse01/works/source/kiwi-descriptions/centos/x86_64/ceph-applicance
bash ./download.sh
cd rpms
rm repodata -rf
createrepo .

echo "Cleaning up the previous build"
mv ~/works/software/kiwi/build/image-root/var/lib/machines/ ~/works/software/kiwi.machines.old-`date "+%d%m%S"`
rm -rf ~/works/software/kiwi/build/image-root/
systemctl restart lvm2-lvmetad.service

echo "Building(comment --debug if you want to a clean output)"
kiwi-ng --debug --color-output --type oem system build --description /home/suse01/works/source/kiwi-descriptions/centos/x86_64/ceph-applicance --target-dir ~/works/software/kiwi
if [ "$?" = "0" ]; then
	echo "Building Successful"
else
	echo "Building fail"
fi
