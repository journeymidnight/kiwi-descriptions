#!/bin/bash

s3_repo_dir=/var/cache/kiwi/yum/cache/repo_samba
s3_repo_url=http://reposamba.los-cn-north-1.lecloudapis.com
token=$1
home=/home/vagrant

if [ "$token" = "" ]; then
	echo "github api token mission, exit"
	exit 127
fi

echo "Downloading repo data from fake repo in s3"
mkdir -p $s3_repo_dir
cd $s3_repo_dir
rm -rf  $s3_repo_url/repodata/repomd.xml $s3_repo_dir/[0-9]*
wget $s3_repo_url/repodata/repomd.xml
grep location  repomd.xml  | sed "s/^.*\"\(.*\)\".*$/wget http:\/\/reposamba.los-cn-north-1.lecloudapis.com\/\1/g" > repomd.sh
bash ./repomd.sh
cd ..

echo "Downloading rpm and binaries(skip TiDB as we do not udpate when necessary)"
cd $home/works/source/kiwi-descriptions/centos/x86_64/ceph-applicance
#bash ./download.sh $token
cd rpms
rm repodata -rf
createrepo .

echo "Cleaning up the previous build"
mv $home/works/software/kiwi/build/image-root/var/lib/machines/ $home/works/software/kiwi.machines.old-`date "+%d%m%S"`
rm -rf $home/works/software/kiwi/build/image-root/
systemctl restart lvm2-lvmetad.service

echo "Building(comment --debug if you want to a clean output)"
kiwi-ng --debug --color-output --type oem system build --description $home/works/source/kiwi-descriptions/centos/x86_64/ceph-applicance --target-dir $home/works/software/kiwi
if [ "$?" = "0" ]; then
	echo "Building Successful"
else
	echo "Building fail"
fi
