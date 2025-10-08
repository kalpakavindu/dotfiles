#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

BRIGHTNESS_DIR="/sys/class/backlight/intel_backlight"

BRIGHTNESS_PATH="$BRIGHTNESS_DIR/brightness"
MAX_BRIGHTNESS=$(cat "$BRIGHTNESS_DIR/max_brightness")

get_brightness () {
  b=$(cat "$BRIGHTNESS_PATH")
  bp=$(echo "$b * 100 / $MAX_BRIGHTNESS" | bc -l | awk '{printf "%.0f", $1}')
  
  if [[ "$bp" -le "10" ]]; then
    echo "󰛩"
    elif [[ "$bp" -le "20" ]]; then
    echo "󱩎"
    elif [[ "$bp" -le "30" ]]; then
    echo "󱩏"
    elif [[ "$bp" -le "40" ]]; then
    echo "󱩑"
    elif [[ "$bp" -le "50" ]]; then
    echo "󱩑"
    elif [[ "$bp" -le "60" ]]; then
    echo "󱩒"
    elif [[ "$bp" -le "70" ]]; then
    echo "󱩓"
    elif [[ "$bp" -le "80" ]]; then
    echo "󱩔"
    elif [[ "$bp" -le "90" ]]; then
    echo "󱩕"
  else
    echo "󰛨"
  fi
  
  eww update back_lev="$bp"
}

set_brightness () {
  if [[ ("$1" -ge "2") && ("$1" -le "100") ]];then
    brightnessctl s "$1"%
  fi
}

toggle_eye () {
  if [[ "$(eww get eye_comf_on)" == "false" ]]; then
    hyprctl hyprsunset temperature $1
    eww update eye_comf_on="true"
  else
    hyprctl hyprsunset identity
    eww update eye_comf_on="false"
  fi
}

if [[ "$1" == "--listen-brightness" ]]; then
  get_brightness
  inotifywait -m -e modify "$BRIGHTNESS_PATH" | while read -r _; do
    get_brightness
  done
fi

case $1 in
  --set) set_brightness "$2" ;;
  --toggle-eye) toggle_eye "$2" ;;
esac
