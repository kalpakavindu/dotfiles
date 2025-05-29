#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

workspaces () {
  focussed=""
  if [[ "$1" == "s" ]]; then
    focussed=$(hyprctl activeworkspace | grep 'workspace ID' | awk '{print $3}')
  else
    focussed=$(echo "$1" | grep -oE '[0-9]+')
  fi

  declare -a ws
  while read -r id; do
    elem=$((id - 1))

    if [[ "$focussed" == "$id" ]]; then
      ws[$elem]="{\"id\":$id,\"active\":1,\"icon\":\"\"}"
    else
      ws[$elem]="{\"id\":$id,\"active\":0,\"icon\":\"\"}"
    fi
  done < <(hyprctl workspaces | grep 'workspace ID' | awk '{print $3}')

  o="["
  for j in "${ws[@]}"; do
    o+="$j,"
  done
  o="${o::-1}]"
  echo "$o"
}

handler () {
  if [[ "$1" == "workspace>>"* ]]; then
    workspaces "$1"
  fi
}

workspaces "s"
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handler "$line"; done