#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

BRIGHTNESS_DIR="/sys/class/backlight/amdgpu_bl2"
if [[ ! -d "$BRIGHTNESS_DIR" ]]; then
  BRIGHTNESS_DIR=$(find /sys/class/backlight/ -maxdepth 1 -mindepth 1 | head -n 1)
fi

BRIGHTNESS_PATH="$BRIGHTNESS_DIR/brightness"
read -r MAX_BRIGHTNESS < "$BRIGHTNESS_DIR/max_brightness"

# Icon array by 10%
ICONS=("󰛩" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󰛨")

get_brightness () {
  local b bp idx icon
  read -r b < "$BRIGHTNESS_PATH"
  bp=$(( (b * 100 + MAX_BRIGHTNESS / 2) / MAX_BRIGHTNESS ))
  idx=$(( bp / 10 ))

  (( idx > 9 )) && idx=9
  (( bp == 100 )) && idx=9

  icon="${ICONS[$idx]}"

  echo "$icon"
  eww update back_lev="$bp"
}

set_brightness () {
  local val="$1"
  if (( val >= 2 && val <= 100 )); then
    brightnessctl s "${val}%"
  fi
}

toggle_eye () {
  local temp="${1:-4500}"

  if [[ "$(eww get eye_comf_on 2>/dev/null)" == "false" ]]; then
    hyprctl hyprsunset temperature "$temp"
    eww update eye_comf_on="true"
  else
    hyprctl hyprsunset identity
    eww update eye_comf_on="false"
  fi
}

listen_brightness () {
  get_brightness
  inotifywait -m -e modify "$BRIGHTNESS_PATH" 2>/dev/null | while read -r _; do
    get_brightness
  done
}

case "$1" in
  --listen-brightness) listen_brightness ;;
  --set)               set_brightness "$2" ;;
  --toggle-eye)        toggle_eye "$2" ;;
  *)                   get_brightness ;;
esac