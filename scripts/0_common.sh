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
# git
if ! command -v git &> /dev/null
then
    echo "git could not be found, please install it first"
    exit
fi
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
# npm
if ! command -v npm &> /dev/null
then
    echo "npm could not be found, please install it first"
    exit
fi
# go
if ! command -v go &> /dev/null
then
    echo "go could not be found, please install it first"
    exit
fi
# docker
if ! command -v docker &> /dev/null
then
    echo "docker could not be found, please install it first"
    exit
fi
# docker-compose
if ! command -v docker-compose &> /dev/null
then
    echo "docker-compose could not be found, please install it first"
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
