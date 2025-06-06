#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

SWAYNC_CACHE_DIR="$XDG_CACHE_HOME/swaync"
SWAYNC_STYLE_FILE="$SWAYNC_CACHE_DIR/style.css"
SWAYNC_CONFIG_FILE="$XDG_CONFIG_HOME/swaync/config.json"

if [[ -d "$SWAYNC_CACHE_DIR" ]];then
  sassc $XDG_CONFIG_HOME/swaync/style.scss $SWAYNC_CACHE_DIR/style.css
else
  mkdir $SWAYNC_CACHE_DIR
  sassc $XDG_CONFIG_HOME/swaync/style.scss $SWAYNC_CACHE_DIR/style.css
fi

# export GTK_DEBUG="interactive" # To open inspector

killall swaync
uwsm app -- swaync -s "$SWAYNC_STYLE_FILE" -c "$SWAYNC_CONFIG_FILE" &