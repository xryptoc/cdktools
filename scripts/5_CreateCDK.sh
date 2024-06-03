#!/bin/bash

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/0_common.sh"

## clone
if [ ! -d "$SRC_DIR/cdk-validium-node" ]; then
    git clone -b ethda https://github.com/crustio/cdk-validium-node $SRC_DIR/cdk-validium-node
fi

## test.genesis.config.json
node $SCRIPT_DIR/js/create_cdk_config.js

## test.node.config.toml
SequencerAddress=$(cat $OUTPUT_DIR/sequencer.addr)
AggregatorAddress=$(cat $OUTPUT_DIR/aggregator.addr)
echo "=============> SequencerAddress: $SequencerAddress"
echo "=============> AggregatorAddress: $AggregatorAddress"

Escaped_L1Host=$(echo "$L1Host" | sed 's#//#\\/\\/#g')
sed -e "s/<SequencerAddress>/$SequencerAddress/g; s/<AggregatorAddress>/$AggregatorAddress/g; s/<L1Host>/$Escaped_L1Host/g" "$SCRIPT_DIR/conf/cdk/test.node.config.toml.tpl" > $SRC_DIR/cdk-validium-node/test/config/test.node.config.toml

## FIX docker compose
if docker compose version > /dev/null 2>&1; then
    echo "Docker Compose is supported as a subcommand."
else
    sed -i "" "s/docker compose/docker-compose/g" "$SRC_DIR/cdk-validium-node/test/Makefile"
fi
## run cdk
cd $SRC_DIR/cdk-validium-node/test && make run-ethda-sepolia