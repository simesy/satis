#!/usr/bin/env bash

for f in app/include/*.json
do
  echo "HI"
  TOOMANY=$(cat "$f" | jq '.packages | [.[] ] | .[] | [.[]] | .[] | .name' | sort | uniq -c | awk '{if($1>1)print$2" "$1}')
  echo "$TOOMANY"
done

#        if [[ ! -z $OUTPUT ]]; then echo "Two many packages for $TOOMANY" && exit 1; fi


