#!/bin/bash

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/0_common.sh"

## clone
if [ ! -d "$SRC_DIR/cdk-validium-node" ]; then
    git clone -b ethda https://github.com/crustio/cdk-validium-node $SRC_DIR/cdk-validium-node
fi

if [ ! -d "$SRC_DIR/cdk-validium-node" ]; then
    echo "CDK clone fail, exit..."
    exit
fi

## build zkevm-node
cd $SRC_DIR/cdk-validium-node
rm Dockerfile && cp $BASE_DIR/scripts/docker/Dockerfile.cdk ./Dockerfile && make build-docker
cd $BASE_DIR

## replace keyd
if [ -f "$SRC_DIR/cdk-validium-node/test/aggregator.keystore" ]; then
    cp $OUTPUT_DIR/aggregator.keystore $SRC_DIR/cdk-validium-node/test/aggregator.keystore
fi
if [ -f "$SRC_DIR/cdk-validium-node/test/sequencer.keystore" ]; then
    cp $OUTPUT_DIR/sequencer.keystore $SRC_DIR/cdk-validium-node/test/sequencer.keystore
fi

## test.genesis.config.json
node $SCRIPT_DIR/js/create_cdk_config.js

## test.node.config.toml
SequencerAddress=$(cat $OUTPUT_DIR/sequencer.addr)
AggregatorAddress=$(cat $OUTPUT_DIR/aggregator.addr)
echo "=============> SequencerAddress: $SequencerAddress"
echo "=============> AggregatorAddress: $AggregatorAddress"

Escaped_L1Host=$(echo "$L1Host" | sed 's#//#\\/\\/#g')
SEDReplaceTo "s/<SequencerAddress>/$SequencerAddress/g; s/<AggregatorAddress>/$AggregatorAddress/g; s/<L1Host>/$Escaped_L1Host/g" "$SCRIPT_DIR/conf/cdk/test.node.config.toml.tpl" > $SRC_DIR/cdk-validium-node/test/config/test.node.config.toml

## FIX docker compose
if docker compose version > /dev/null 2>&1; then
    echo "Docker Compose is supported as a subcommand."
else
    SEDReplaceSelf "s/docker compose/docker-compose/g" "$SRC_DIR/cdk-validium-node/test/Makefile"
fi
## run cdk
cd $SRC_DIR/cdk-validium-node/test && make run-ethda-sepolia
