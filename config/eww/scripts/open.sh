#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

toggle_window() {
  local open='0'
  
  while IFS=" : " read -r _ wname; do
    if [[ "$wname" == *"_popup" ]]; then
      if [[ "$1" == "$wname" ]]; then
        open='1'
      fi
      
      eww close "$wname" > /dev/null 2>&1
      
    fi
  done < <(eww active-windows)
  
  if [[ "$open" == "1" ]]; then
    eww close "$1"
  else
    eww open "$1"
  fi
}

toggle_window $1