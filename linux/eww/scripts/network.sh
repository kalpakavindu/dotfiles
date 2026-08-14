#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

CURRENT_INTERFACE=""
CURRENT_IP=""
CURRENT_CONNECTION_NAME=""

is_wifi_enabled () {
  o=$(nmcli -f WIFI r | awk 'NR>1 {print $1}')
  if [[ "$o" == "enabled" ]];then
    echo "1"
  else
    echo "0"
  fi
}

get_current_interface () {
  CURRENT_INTERFACE=""
  CURRENT_IP=""
  CURRENT_CONNECTION_NAME=""

  local _ dev
  read -r _ _ _ _ dev _ < <(ip route show default 2>/dev/null)

  if [[ -n "$dev" ]]; then
    CURRENT_INTERFACE="$dev"

    local ip_line
    read -r _ ip_line _ < <(ip -4 addr show dev "$dev" scope global 2>/dev/null | grep -w inet)
    CURRENT_IP="${ip_line%%/*}"

    CURRENT_CONNECTION_NAME=$(nmcli -t -f DEVICE,NAME c show --active 2>/dev/null | awk -F: -v d="$dev" '$1==d {print $2; exit}')
  fi
}

get_enp_list () {
  local list="[]"
  local items=()
  local ifname type state cname

  while IFS=':' read -r ifname type state cname; do
    if [[ "$type" == "ethernet" && "$state" == "connected" ]]; then
      local inuse=0
      [[ "$CURRENT_INTERFACE" == "$ifname" ]] && inuse=1

      cname="${cname//\"/\\\"}"
      items+=("{\"ifname\":\"$ifname\",\"cname\":\"$cname\",\"inuse\":$inuse}")
    fi
  done < <(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION device)

  if (( ${#items[@]} > 0 )); then
    local joined
    joined=$(printf ",%s" "${items[@]}")
    list="[${joined:1}]"
  fi

  eww update net_enp_list="$list"
}

get_icon () {
  if [[ "$CURRENT_INTERFACE" == "enp"* ]]; then
    echo ""
    elif [[ "$CURRENT_INTERFACE" == "wl"* ]]; then
    echo "󰖩"
  else
    echo ""
  fi
}

get_wifi_icon () {
  local signal="${1//[^0-9]/}"
  local secured="$2"
  [[ -z "$signal" ]] && signal=0

  local idx=$(( signal / 25 ))
  (( idx > 3 )) && idx=3

  if (( secured == 1 )); then
    local icons=("󰤡" "󰤤" "󰤧" "󰤪")
    echo "${icons[$idx]}"
  else
    local icons=("󰤟" "󰤢" "󰤥" "󰤨")
    echo "${icons[$idx]}"
  fi
}

is_wifi_secured () {
  o=$(nmcli -f bssid,security dev wifi list bssid $1 | awk 'NR == 2 {print $2}')
  if [[ "$o" == "None" ]]; then
    echo 0
  else
    echo 1
  fi
}

is_wifi_inuse () {
  o=$(nmcli -f bssid,in-use d wifi | grep "*" | awk '{print $1}')
  if [[ "$o" == "$1" ]];then
    echo 1
  else
    echo 0
  fi
}

get_wifi () {
  if [[ "$(is_wifi_enabled)" == "1" ]];then
    d="{}"
    while IFS=" " read -r bssid signal ssid; do
      icon=$(get_wifi_icon "$signal" "$(is_wifi_secured $bssid)")
      inuse=$(is_wifi_inuse "$bssid")
      
      if [[ "$inuse" == "1" ]]; then
        d="{\"bssid\":\"$bssid\",\"signal\":$signal,\"ssid\":\"${ssid//%sep%/' '}\",\"icon\":\"$icon\"}"
      fi
      done < <(nmcli -f BSSID,SIGNAL,SSID d wifi list --rescan yes | awk 'NR>1 {
      ssid = ""
      for (i = 3; i <= NF; i++) {
        ssid = ssid $i "%sep%"
      }
      sub(/%sep%*$/, "", ssid)
      print $1 " " $2 " " ssid
    }')
    eww update net_wifi="$d"
  fi
}

toggle_wifi () {
  if [[ "$(is_wifi_enabled)" == "1" ]]; then
    eww update net_wifi_active=false net_wifi='{}' 2>/dev/null
    nmcli r wifi off
  else
    nmcli r wifi on
    get_wifi
    eww update net_wifi_active=true 2>/dev/null
  fi
}

update_all_net () {
  get_current_interface
  get_icon

  eww update net_ifname="$CURRENT_INTERFACE" 2>/dev/null
  get_enp_list
  get_wifi
}

if [[ "$(is_wifi_enabled)" == "1" ]];then
  get_wifi
  eww update net_wifi_active=true
else
  eww update net_wifi_active=false
fi

case $1 in
  --listen-icon)
    update_all_net
    
    nmcli m | while read -r line; do
      update_all_net
    done
  ;;
  
  --toggle-wifi) toggle_wifi ;;
esac