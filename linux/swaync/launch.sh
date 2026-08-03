#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

SWAYNC_CACHE_DIR="$XDG_CACHE_HOME/swaync"
SWAYNC_STYLE_FILE="$SWAYNC_CACHE_DIR/style.css"
SWAYNC_CONFIG_FILE="$XDG_CONFIG_HOME/swaync/config.json"

if [[ ! -d "$SWAYNC_CACHE_DIR" ]];then
  mkdir $SWAYNC_CACHE_DIR
fi

sassc $XDG_CONFIG_HOME/swaync/style.scss $SWAYNC_CACHE_DIR/style.css

# Uncommenting following line will open inspector
# export GTK_DEBUG="interactive"

killall swaync
uwsm app -- swaync -s "$SWAYNC_STYLE_FILE" -c "$SWAYNC_CONFIG_FILE" &