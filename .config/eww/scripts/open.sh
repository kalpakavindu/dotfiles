#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

powermenu () {
  eww open --toggle powermenu_popup
}

calendar () {
  eww open --toggle calendar_popup
}

audio () {
  eww open --toggle audio_popup
}

backlight () {
  eww open --toggle backlight_popup
}

battery () {
  eww open --toggle battery_popup
}

network () {
  eww open --toggle network_popup
}

case $1 in
  --calendar) calendar ;;
  --audio) audio ;;
  --backlight) backlight ;;
  --battery) battery ;;
  --network) network ;;
  --powermenu) powermenu ;;
esac