#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

BAT=$(ls /sys/class/power_supply | grep BAT | head -n 1) # ls the /sys/class/power_supply/ and set the name of the dir for your battery
SUP=$(ls /sys/class/power_supply | grep ACAD | head -n 1) # ls the /sys/class/power_supply/ and set the name of the dir for your charger

BATTERY_PATH="/sys/class/power_supply/$BAT"
PLUG_PATH="/sys/class/power_supply/$SUP"

capacity () {
  cat $BATTERY_PATH/capacity
}

is_battery_available () {
  cat $BATTERY_PATH/present
}

is_plugged () {
  cat $PLUG_PATH/online
}

design_charge () {
  x=$(cat $BATTERY_PATH/charge_full_design)
  echo $(( x / 1000 ))
}

get_charge() {
  x=$(cat $BATTERY_PATH/charge_full)
  y=$(cat $BATTERY_PATH/charge_full_design)
  echo "$x / $y * 100" | bc -l | awk '{printf "%.2f", $1}'
  echo
}

get_icon () {
  # Update eww on every time function calls
  eww update bat_chr="$(get_charge)"
  eww update bat_cap="$(capacity)"

  if [[ "$(is_battery_available)" == "1" ]]; then
    if [[ "$(is_plugged)" == "1" ]]; then
      echo "󰂄"
    else
      cap=$(capacity)
      if [[ "$cap" -le "10" ]]; then
        echo "󰁺"
      elif [[ "$cap" -le "20" ]]; then
        echo "󰁻"
      elif [[ "$cap" -le "30" ]]; then
        echo "󰁼"
      elif [[ "$cap" -le "40" ]]; then
        echo "󰁽"
      elif [[ "$cap" -le "50" ]]; then
        echo "󰁾"
      elif [[ "$cap" -le "60" ]]; then
        echo "󰁿"
      elif [[ "$cap" -le "70" ]]; then
        echo "󰂀"
      elif [[ "$cap" -le "80" ]]; then
        echo "󰂁"
      elif [[ "$cap" -le "90" ]]; then
        echo "󰂂"
      else
        echo "󰁹"
      fi
    fi
  else
    if [[ "$(is_plugged)" == "1" ]]; then
      echo ""
    else
      echo "󰂃"
    fi
  fi
}

eww update bat_chr_def="$(design_charge)"

case $1 in
  --capacity) capacity ;;
  --is_plugged) is_plugged ;;
  --design-charge) design_charge ;;
  --charge) get_charge ;;
  --icon) get_icon ;;
esac