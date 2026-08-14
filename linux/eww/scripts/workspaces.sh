#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

workspaces () {
  local focussed=""
  
  if [[ "$1" == "s" ]]; then
    focussed=$(hyprctl activeworkspace | grep -oP 'workspace ID \K-?\d+')
  else
    focussed=$(echo "$1" | grep -oE '[0-9]+')
  fi

  local ws=()
  
  while read -r id; do
    [[ -z "$id" ]] && continue

    local active=0
    local icon=""

    # Check active state
    if [[ "$focussed" == "$id" ]]; then
      active=1
      icon=""
    fi

    # # Handle special/negative workspace icon
    # if (( id < 1 )); then
    #   icon="󰰣"
    # fi

    
    if (( id > 0 )); then
      # Append formatted JSON object safely to array
      ws+=("{\"id\":$id,\"active\":$active,\"icon\":\"$icon\"}")
    fi

  done < <(hyprctl workspaces | grep -oP 'workspace ID \K-?\d+')

  # Join array elements into a valid JSON array
  local output
  output=$(printf ",%s" "${ws[@]}")
  echo "[${output:1}]"
}

handler () {
  if [[ "$1" == "workspace>>"* ]]; then
    workspaces "$1"
  fi
}

workspaces "s"
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handler "$line"; done