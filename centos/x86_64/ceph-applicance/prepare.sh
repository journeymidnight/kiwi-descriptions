#!/bin/bash

set -e
trap abort ERR

token=$1
home=/home/vagrant

if [ "$token" = "" ]; then
	echo "github api token mission, exit"
	exit 127
fi

echo "Downloading rpm and binaries"
cd $home/works/source/kiwi-descriptions/centos/x86_64/ceph-applicance
bash ./download.sh $token
cd rpms
rm repodata -rf
createrepo .
cd ..
tar zcvf binaries.tar.gz binaries

