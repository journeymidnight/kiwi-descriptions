#!/bin/bash

account="bjzhang"
token="2534b89f255c4fc100aaee5ec5b6cb152256e659"

download_rpms()
{
	user=$1
	repo=$2
	type=$3
	filelist=$4
	files=`curl -u $account:$token -s https://api.github.com/repos/$user/$repo/releases/latest | grep "browser_download_url" | grep "\.$type" | cut -d \" -f 4`
	for f in $files; do
		if [ "$filelist" != "" ]; then
			for want in $filelist; do
				echo "${f##*/}" | grep "^$want\-[0-9].*$" > /dev/null
				if [ "$?" = 0 ]; then
					echo "$downloading $f"
					curl -O -u $account:$token -L $f
					break
				else
					continue
				fi
			done
		else
			echo "$downloading $f"
			curl -O -u $account:$token -L $f
		fi
	done
}

download_all_tars()
{
	user=$1
	repo=$2
	url=`curl -u $account:$token -s https://api.github.com/repos/$user/$repo/releases/latest | grep "tarball_url" | cut -d \" -f 4`
	echo $url
	curl -o ${repo}_${url##*/}.tar.gz -u $account:$token -L $url
}

cd rpms
download_rpms journeymidnight nier rpm
#download_rpms journeymidnight niergui rpm
download_rpms journeymidnight automata rpm
#download_rpms journeymidnight prometheus-rpm rpm "ceph_exporter node-exporter prometheus"
cd ..
#cd binaries
#download_all_tars journeymidnight storedeployer
#curl -O -L http://download.pingcap.org/tidb-latest-linux-amd64.tar.gz
#curl -O -L http://download.pingcap.org/tidb-latest-linux-amd64.sha256
#sha256sum -c tidb-latest-linux-amd64.sha256
#if [ $? != 0 ]; then
#	echo "download tidb failed. exit!"
#	exit 127
#fi
#cd ..
#tar zcvf binaries.tar.gz binaries
