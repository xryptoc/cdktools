#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BASE_DIR=$SCRIPT_DIR/..
SRC_DIR=$SCRIPT_DIR/data/src
BIN_DIR=$SCRIPT_DIR/data/bin
KEYSTORE_DIR=$SCRIPT_DIR/data/keystore

## output dir
OUTPUT_DIR=$SCRIPT_DIR/output

AGGREGATOR_KEYSTORE_NAME=aggregator.keystore
SEQUENCER_KEYSTORE_NAME=sequencer.keystore

## L1
ALWAYS_RESTART_L1=1      ## 0 / 1
## sepolia-mock IP
L1Host=http://172.22.86.46:8545

## rullop
INFURA_PROJECT_ID=ed3476b5d5674cd59be4a198bcf83a1b

## cdk
CDKHost=http://192.168.18.183:8123

## check dependencies
# jq
if ! command -v jq &> /dev/null
then
    echo "jq could not be found, please install it first"
    exit
fi
# node
if ! command -v node &> /dev/null
then
    echo "node could not be found, please install it first"
    exit
fi

SEDReplaceTo() {
    local os=$(uname)

    if [[ $os == "Darwin" ]]; then
        sed -e "$@"
    else
        sed "$@"
    fi
}

SEDReplaceSelf() {
    local os=$(uname)
    local options=""

    if [[ $os == "Darwin" ]]; then
        options="-i ''"
    else
        options="-i"
    fi

    sed $options "$@"
}
