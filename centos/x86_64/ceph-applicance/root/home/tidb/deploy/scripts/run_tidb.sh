#!/bin/bash
set -e

ulimit -n 1000000

# WARNING: This file was auto-generated. Do not edit!
#          All your edit might be overwritten!
DEPLOY_DIR=/home/tidb/deploy

cd "${DEPLOY_DIR}" || exit 1

exec bin/tidb-server \
    -P 4000 \
    --status="10080" \
    --config=conf/tidb.toml \
    --log-file="/home/tidb/deploy/log/tidb.log" 2> "/home/tidb/deploy/log/tidb_stderr.log"
