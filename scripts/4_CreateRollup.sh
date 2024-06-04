#!/bin/bash

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/0_common.sh"

## clone contracts src
if [ ! -d "$SRC_DIR/zkevm-contracts" ]; then
    git clone -b feat/support-ethda-da https://github.com/crustio/zkevm-contracts $SRC_DIR/zkevm-contracts
else
    echo "zkevm-contracts exists, skip clone"
fi

## env
if [ -f "$SRC_DIR/zkevm-contracts/.env" ]; then
    rm -f $SRC_DIR/zkevm-contracts/.env
fi
envfile=$SCRIPT_DIR/conf/contracts/.env.tpl
outputPath=$SRC_DIR/zkevm-contracts/.env

replacement_string=$(cat "$OUTPUT_DIR/sequencer.mnemonic")

SEDReplaceTo "s/<MNEMONIC>/$replacement_string/g; s/<InfraID>/$INFURA_PROJECT_ID/g;" "$envfile" > $outputPath

## parameters
Escaped_CDKHost=$(echo "$CDKHost" | sed 's#//#\\/\\/#g')
SequencerAddress=$(cat $OUTPUT_DIR/sequencer.addr)
AggregatorAddress=$(cat $OUTPUT_DIR/aggregator.addr)
echo "=============> SequencerAddress: $SequencerAddress"
echo "=============> AggregatorAddress: $AggregatorAddress"

SEDReplaceTo "s/<SAddr>/$SequencerAddress/g; s/<Aaddr>/$AggregatorAddress/g" "$SCRIPT_DIR/conf/contracts/deploy_parameters.json.tpl" > $SRC_DIR/zkevm-contracts/deployment/v2/deploy_parameters.json
SEDReplaceTo "s/<SAddr>/$SequencerAddress/g; s/<CDKHost>/$Escaped_CDKHost/g" "$SCRIPT_DIR/conf/contracts/create_rollup_parameters.json.tpl" > $SRC_DIR/zkevm-contracts/deployment/v2/create_rollup_parameters.json

# create rollup
cd $SRC_DIR/zkevm-contracts && npm i && npm run deploy:testnet:v2:localhost && cd -