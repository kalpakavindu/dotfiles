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
  interface=$(ip route | grep "default" | awk 'NR==1 {print $5}')
  if [[ "$interface" == "" ]]; then
    CURRENT_INTERFACE=""
    CURRENT_IP=""
    CURRENT_CONNECTION_NAME=""
    return
  fi
  CURRENT_INTERFACE="$interface"
  CURRENT_IP=$(ip addr show dev $interface | grep -w inet | awk '{print $2}')
  CURRENT_CONNECTION_NAME=$(nmcli -f 'device,name' c show --active | grep -w "$interface" | awk 'NR==1 {
    n = ""
    for (i = 2; i <= NF; i++) {
      n = n $i " "
    }
    sub(/ *$/, "", n)
    print n
  }')
}

get_enp_list () {
  if [[ "$(nmcli d | grep ethernet | grep connected)" == "" ]]; then
    list="[]"
  else
    list=""
    while IFS=" " read -r ifname cname; do
      if [[ "$CURRENT_INTERFACE" == "$ifname" ]]; then
        list+="{\"ifname\":\"$ifname\",\"cname\":\"${cname//%sep%/' '}\",\"inuse\":1},"
      else
        list+="{\"ifname\":\"$ifname\",\"cname\":\"${cname//%sep%/' '}\",\"inuse\":0},"
      fi
      done < <(nmcli d | grep "ethernet" | grep "connected" | awk '{
      c = ""
      for (i = 4; i<= NF; i++) {
        c = c $i "%sep%"
      }
      sub(/%sep%*$/, "", c)
      print $1 " " c
    }')
    list="[${list::-1}]"
  fi
  eww update net_enp_list="$list"
}

get_icon () {
  if [[ "$CURRENT_INTERFACE" == "enp"* ]]; then
    echo ""
    elif [[ "$CURRENT_INTERFACE" == "wlp"* ]]; then
    echo "󰖩"
  else
    echo ""
  fi
}

get_wifi_icon () {
  if [[ "$2" == 1 ]]; then
    if [[ "$1" -le "25" ]];then
      echo "󰤡"
      elif [[ "$1" -le "50" ]]; then
      echo "󰤤"
      elif [[ "$1" -le "75" ]]; then
      echo "󰤧"
    else
      echo "󰤪"
    fi
  else
    if [[ "$1" -le "25" ]];then
      echo "󰤟"
      elif [[ "$1" -le "50" ]]; then
      echo "󰤢"
      elif [[ "$1" -le "75" ]]; then
      echo "󰤥"
    else
      echo "󰤨"
    fi
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
    eww update net_wifi_active=false
    nmcli r wifi off
    eww update net_wifi='{}'
  else
    nmcli r wifi on
    get_wifi
    eww update net_wifi_active=true
  fi
}

if [[ "$(is_wifi_enabled)" == "1" ]];then
  get_wifi
  eww update net_wifi_active=true
else
  eww update net_wifi_active=false
fi

case $1 in
  --listen-icon)
    get_current_interface
    eww update net_ifname="$CURRENT_INTERFACE"
    get_icon
    get_enp_list
    get_wifi
    nmcli m | while read -r line; do
      get_current_interface
      eww update net_ifname="$CURRENT_INTERFACE"
      get_icon
      get_enp_list
      get_wifi
    done
  ;;
  
  --toggle-wifi) toggle_wifi ;;
esac