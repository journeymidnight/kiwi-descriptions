#!/bin/bash

account="bjzhang"
token=$1
CURL="curl --proxy localhost:8228"

download_asset()
{
	user=$1
	repo=$2
	json=$3
	filelist=$4
	ids=`echo $json | jq '.assets[]' | jq "[.id][]"`
	for id in $ids; do
		name=`echo $json | jq '.assets[]' | jq "[.id, .name][]" | grep $id -A1 | tail -n1 | sed "s/\"//g"`
		if [ "$filelist" != "" ]; then
			for want in $filelist; do
				echo "${name##*/}" | grep "^$want\-[0-9].*$" > /dev/null
				ret=$?
				if [ "$ret" = "0" ]; then
					echo "downloading $name"
					$CURL -o $name -L -H "Accept: application/octet-stream" -u $account:$token https://api.github.com/repos/$user/$repo/releases/assets/$id
					break
				else
					continue
				fi
			done
		else
			echo "downloading $name"
			$CURL -o $name -L -H "Accept: application/octet-stream" -u $account:$token https://api.github.com/repos/$user/$repo/releases/assets/$id
		fi
	done
}

download_rpms()
{
	user=$1
	repo=$2
	type=$3
	filelist=$4
	echo $filelist
	json=`$CURL -u $account:$token -s https://api.github.com/repos/$user/$repo/releases/latest`
	if [ "$filelist" = "" ]; then
		download_asset $user $repo "$json"
	else
		download_asset $user $repo "$json" "$filelist md5sum.txt"
	fi
	md5sum -c md5sum.txt
	ret="$?"
	if [ "$ret" = "0" ]; then
		echo "md5 check pass:"
		cat md5sum.txt
	else
		echo "md5 check fail, exit:"
		cat md5sum.txt
		exit
	fi
	rm md5sum.txt
}

download_all_tars()
{
	user=$1
	repo=$2
	url=`$CURL -u $account:$token -s https://api.github.com/repos/$user/$repo/releases/latest | grep "tarball_url" | cut -d \" -f 4`
	echo $url
	$CURL -o ${repo}_${url##*/}.tar.gz -u $account:$token -L $url
}


function abort {
	echo "Abort from $0"
}

set -e
trap abort ERR

if [ "$token" = "" ]; then
	echo "github api token mission, exit"
	exit 127
fi
echo "Cleaning up"
mkdir -p rpms binaries
rm -rf rpms/*

echo "Downloading rpms"
cd rpms
download_rpms journeymidnight nier rpm
download_rpms journeymidnight niergui rpm
download_rpms journeymidnight automata rpm
download_rpms journeymidnight prometheus-rpm rpm
cd ..
echo "Downloading binaries"
cd binaries
rm storedeployer* -rf
download_all_tars journeymidnight storedeployer
rm tidb-v1.0.6-linux-amd64.sha256
$CURL -O -L http://download.pingcap.org/tidb-v1.0.6-linux-amd64.sha256
sha256sum -c tidb-v1.0.6-linux-amd64.sha256
if [ $? != 0 ]; then
	echo "tidb mising. download it!"
	rm -rf tidb-v1.0.6-linux-amd64.tar.gz
	$CURL -O -L http://download.pingcap.org/tidb-v1.0.6-linux-amd64.tar.gz
	tar zxf tidb-v1.0.6-linux-amd64.tar.gz
else
	echo "tidb exist. continue"
fi
sha256sum -c tidb-v1.0.6-linux-amd64.sha256
if [ $? != 0 ]; then
	echo "download tidb failed. exit!"
	exit 127
fi
cd ..

