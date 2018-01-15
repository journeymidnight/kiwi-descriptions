#!/bin/bash
set -e
ulimit -n 1000000

# WARNING: This file was auto-generated. Do not edit!
#          All your edit might be overwritten!
DEPLOY_DIR=/home/tidb/deploy

cd "${DEPLOY_DIR}" || exit 1

exec bin/pd-server \
    --data-dir="/home/tidb/deploy/data.pd" \
    --config=conf/pd.toml \
    --log-file="/home/tidb/deploy/log/pd.log" 2> "/home/tidb/deploy/log/pd_stderr.log"
