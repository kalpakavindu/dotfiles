#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

BATTERY_PATH=""
PLUG_PATH=""

for path in /sys/class/power_supply/BAT* /sys/class/power_supply/BATT*; do
  if [[ -d "$path" ]]; then
    BATTERY_PATH="$path"
    break
  fi
done

for path in /sys/class/power_supply/AC* /sys/class/power_supply/ACAD* /sys/class/power_supply/ADP*; do
  if [[ -d "$path" ]]; then
    PLUG_PATH="$path"
    break
  fi
done

# Icon array by 10%
ICONS=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")

capacity () {
  local cap=0
  [[ -f "$BATTERY_PATH/capacity" ]] && read -r cap < "$BATTERY_PATH/capacity"
  echo "$cap"
}

is_battery_available () {
  local present=0
  [[ -f "$BATTERY_PATH/present" ]] && read -r present < "$BATTERY_PATH/present"
  echo "$present"
}

is_plugged () {
  local online=0
  [[ -f "$PLUG_PATH/online" ]] && read -r online < "$PLUG_PATH/online"
  echo "$online"
}

design_charge () {
  local fd=0
  if [[ -f "$BATTERY_PATH/energy_full_design" ]]; then
    read -r fd < "$BATTERY_PATH/energy_full_design"
  elif [[ -f "$BATTERY_PATH/charge_full_design" ]]; then
    read -r fd < "$BATTERY_PATH/charge_full_design"
  fi
  echo $(( fd / 1000 ))
}

get_charge () {
  local full=0 full_design=0

  if [[ -f "$BATTERY_PATH/energy_full" ]]; then
    read -r full < "$BATTERY_PATH/energy_full"
    read -r full_design < "$BATTERY_PATH/energy_full_design"
  elif [[ -f "$BATTERY_PATH/charge_full" ]]; then
    read -r full < "$BATTERY_PATH/charge_full"
    read -r full_design < "$BATTERY_PATH/charge_full_design"
  fi

  if (( full_design > 0 )); then
    local val=$(( (full * 10000) / full_design ))
    printf "%d.%02d\n" $(( val / 100 )) $(( val % 100 ))
  else
    echo "0.00"
  fi
}

get_icon () {
  local cap present online charge_pct design_cap
  cap=$(capacity)
  present=$(is_battery_available)
  online=$(is_plugged)
  charge_pct=$(get_charge)
  design_cap=$(design_charge)

  eww update bat_chr="$charge_pct" bat_cap="$cap" bat_chr_def="$design_cap" 2>/dev/null

  if (( present == 1 )); then
    if (( online == 1 )); then
      echo "󰂄"
    else
      local idx=$(( (cap - 1) / 10 ))
      (( idx < 0 )) && idx=0
      (( idx > 9 )) && idx=9
      echo "${ICONS[$idx]}"
    fi
  else
    if (( online == 1 )); then
      echo ""
    else
      echo "󰂃"
    fi
  fi
}

case "$1" in
  --capacity)      capacity ;;
  --is_plugged)    is_plugged ;;
  --design-charge) design_charge ;;
  --charge)        get_charge ;;
  --icon)          get_icon ;;
esac