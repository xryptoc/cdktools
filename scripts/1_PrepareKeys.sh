#!/bin/bash
 
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/0_common.sh"

## pull evmkey
if [ ! -d "$SRC_DIR/evmkey" ]; then
    git clone -b v1.0.5 https://github.com/crustio/evmkey $SRC_DIR/evmkey
fi

## build evmkey
if [ ! -f "$BIN_DIR/evmkey" ]; then
    cd  $SRC_DIR/evmkey && go build -ldflags="-w -s" -o $BIN_DIR/evmkey $SRC_DIR/evmkey && cd -
fi

## prepare aggreator
EVMKEY_BIN=$BIN_DIR/evmkey

## create output dir
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p $OUTPUT_DIR
fi

## clean keystore dir
if [ -d "$KEYSTORE_DIR" ]; then
    rm -rf $KEYSTORE_DIR
fi
## clean aggregator keystore
# if [ -f "$OUTPUT_DIR/aggregator.keystore" ]; then 
    rm -f $OUTPUT_DIR/aggregator.*
    rm -f $OUTPUT_DIR/sequencer.*
# fi

## create aggregator keystore
$EVMKEY_BIN --keystore $KEYSTORE_DIR --password testonly account new
## rename aggregator
find "$KEYSTORE_DIR" -type f -name "*.keystore" -exec bash -c 'basename "$1" "$2" | sed "s/$2$//" >> "$3"' _ {} ".keystore" "$OUTPUT_DIR/aggregator.addr" \;
find $KEYSTORE_DIR -name "*.keystore" -exec cp {} $OUTPUT_DIR/aggregator.keystore \;
## delete origin aggregator
rm -f $KEYSTORE_DIR/*

## create sequencer keystore
$EVMKEY_BIN --keystore $KEYSTORE_DIR --password testonly account new
## rename sequencer
find "$KEYSTORE_DIR" -type f -name "*.keystore" -exec bash -c 'basename "$1" "$2" | sed "s/$2$//" >> "$3"' _ {} ".keystore" "$OUTPUT_DIR/sequencer.addr" \;
find $KEYSTORE_DIR -name "*.keystore" -exec cp {} $OUTPUT_DIR/sequencer.keystore \;
find $KEYSTORE_DIR -name "*.mnemonic" -exec cp {} $OUTPUT_DIR/sequencer.mnemonic \;
## delete origin sequencer
rm -f $KEYSTORE_DIR/*





