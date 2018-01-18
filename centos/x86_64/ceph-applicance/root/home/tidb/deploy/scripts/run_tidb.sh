#!/bin/bash
set -e

ulimit -n 1000000

# WARNING: This file was auto-generated. Do not edit!
#          All your edit might be overwritten!
DEPLOY_DIR=/home/tidb/deploy

cd "${DEPLOY_DIR}" || exit 1

export hostname=$(hostname)

status_code=$(/usr/bin/curl --connect-timeout 3 -s -o /dev/null -w ''%{http_code}'' http://${hostname}:2379/pd/api/v1/members)

if [[ $status_code != "200" ]] ;then
    exit 1
fi

exec bin/tidb-server \
    -P 4000 \
    --status="10080" \
    --config=conf/tidb.toml \
    --log-file="/home/tidb/deploy/log/tidb.log" 2> "/home/tidb/deploy/log/tidb_stderr.log"
