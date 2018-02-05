#!/bin/bash

function abort {
	echo "Abort at $1 from $0."
}

set -e
trap 'abort $LINENO' ERR

token=$1
home=/home/vagrant

if [ "$token" = "" ]; then
	echo "github api token mission, exit"
	exit 127
fi

s3_repo_dir=/var/cache/kiwi/yum/cache/repo_samba
s3_repo_url=https://reposamba.los-cn-north-1.lecloudapis.com
echo "Downloading repo data from fake repo in s3"
mkdir -p $s3_repo_dir
cd $s3_repo_dir
rm -rf  $s3_repo_dir/repomd.xml $s3_repo_dir/[0-9]*
wget $s3_repo_url/repodata/repomd.xml
grep location  repomd.xml  | sed "s/^.*\"\(.*\)\".*$/wget http:\/\/reposamba.los-cn-north-1.lecloudapis.com\/\1/g" > repomd.sh
bash ./repomd.sh
cd ..

echo "Downloading rpm and binaries"
cd $home/works/source/kiwi-descriptions/centos/x86_64/ceph-applicance
./download.sh $token
cd rpms
rm repodata -rf
createrepo .
cd ..
tar zcvf binaries.tar.gz binaries

