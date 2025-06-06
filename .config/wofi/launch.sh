#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

WOFI_CACHE_DIR="$XDG_CACHE_HOME/wofi"
WOFI_STYLE_FILE="$WOFI_CACHE_DIR/style.css"
WOFI_CONFIG_FILE="$XDG_CONFIG_HOME/wofi/config"

if [[ -d "$WOFI_CACHE_DIR" ]];then
  sassc $XDG_CONFIG_HOME/wofi/style.scss $WOFI_CACHE_DIR/style.css
else
  mkdir $WOFI_CACHE_DIR
  sassc $XDG_CONFIG_HOME/wofi/style.scss $WOFI_CACHE_DIR/style.css
fi

toggle (){
  ps cax | grep wofi > /dev/null
  if [ $? -eq 0 ]; then
    killall wofi
  else
    uwsm app -- wofi -s "$WOFI_STYLE_FILE" -c "$WOFI_CONFIG_FILE" &
  fi
}

dmenu(){
  wofi -s "$WOFI_STYLE_FILE" -c "$WOFI_CONFIG_FILE" --dmenu
}


case $1 in
  -t) toggle ;;
  -dm) dmenu ;;
esac