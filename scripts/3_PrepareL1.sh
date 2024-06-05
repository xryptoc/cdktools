#!/bin/bash

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/0_common.sh"

## stop geth
if [ $ALWAYS_RESTART_L1 -eq 1 ]; then
  DEV_PERIOD=1 docker-compose -f $SCRIPT_DIR/docker/docker-compose.yml down
  sudo rm -rf $SCRIPT_DIR/docker/gethData
  sleep 1
fi

## run geth L1 node
DEV_PERIOD=1 docker-compose -f $SCRIPT_DIR/docker/docker-compose.yml up -d geth
sleep 4

## fund accounts
node $SCRIPT_DIR/js/fund-accounts.js

