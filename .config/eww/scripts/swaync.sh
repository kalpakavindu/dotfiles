#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

listener(){
  swaync-client -s | while read -r line; do
    count=$(echo "$line" | jq -r ".count")
    dnd=$(echo "$line" | jq -r ".dnd")

    eww update not_count="$count"

    if [[ "$dnd" == "true" ]]; then
      echo "󰂛"
    elif [[ "$count" == "0" ]]; then
      echo "󰂚"
    else
      echo "󱅫"
    fi
  done
}


case $1 in
 --listen) listener ;;
esac