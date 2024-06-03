#!/bin/bash
 
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/0_common.sh"

if [ -f "$BASE_DIR/.env" ]; then
    rm -f $BASE_DIR/.env
fi

envfile=$SCRIPT_DIR/conf/.env.tpl
outputPath=$BASE_DIR/.env

replacement_string=$(cat "$OUTPUT_DIR/sequencer.mnemonic")

if [[ $(uname) == "Darwin" ]]; then
  sed -e "s/<MNEMONIC>/$replacement_string/g" "$envfile" > $outputPath
elif [[ $(uname) == "Linux" ]]; then
  sed -i "s/<MNEMONIC>/$replacement_string/g" "$envfile" > $outputPath
else
  echo "Error: Unknown operating system, expect Mac or Linux"
fi
