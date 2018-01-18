#!/bin/bash
set -e
ulimit -n 1000000

# WARNING: This file was auto-generated. Do not edit!
#          All your edit might be overwritten!
cd "/home/tidb/deploy" || exit 1

export RUST_BACKTRACE=1

export TZ=${TZ:-/etc/localtime}

echo -n 'sync ... '
stat=$(time sync)
echo ok
echo $stat

#check pd is working
export hostname=$(hostname)

status_code=$(/usr/bin/curl --connect-timeout 3 -s -o /dev/null -w ''%{http_code}'' http://${hostname}:2379/pd/api/v1/members)

if [[ $status_code = "200" ]] ;then
    echo $$ > "status/tikv.pid"
else
    exit 1
fi

exec bin/tikv-server \
    --addr "0.0.0.0:20160" \
    --data-dir "/home/tidb/deploy/data" \
    --config conf/tikv.toml \
    --log-file "/home/tidb/deploy/log/tikv.log" 2> "/home/tidb/deploy/log/tikv_stderr.log"
