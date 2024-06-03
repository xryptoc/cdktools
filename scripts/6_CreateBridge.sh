#!/bin/bash

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/0_common.sh"

## clone
if [ ! -d "$SRC_DIR/zkevm-bridge-service" ]; then
    git clone -b develop https://github.com/0xPolygonHermez/zkevm-bridge-service.git $SRC_DIR/zkevm-bridge-service
fi
if [ ! -d "$SRC_DIR/zkevm-bridge-ui" ]; then
    git clone -b develop https://github.com/0xPolygonHermez/zkevm-bridge-ui.git $SRC_DIR/zkevm-bridge-ui
fi

## service config


## ui config

