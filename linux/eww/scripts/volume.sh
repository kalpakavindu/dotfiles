#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

# Helpers --------
get_sink_info () {
  local sink
  sink=$(pactl get-default-sink 2>/dev/null)
  echo "${sink%%.*} | ${sink##*.}"
}

get_source_info () {
  local source
  source=$(pactl get-default-source 2>/dev/null)
  echo "${source%%.*} | ${source##*.}"
}

get_server_info () {
  local line
  while IFS= read -r line; do
    if [[ "$line" == "Server Name: "* ]]; then
      echo "${line#Server Name: }"
      return
    fi
  done < <(pactl info 2>/dev/null)
}
# ----------------

# Volume --------
vol_set () {
  local val="$1"
  (( val >= 0 && val <= 100 )) && pamixer --set-volume "$val"
}

vol_toggle () {
  pamixer -t
}

update_vol () {
  local vol muted icon dev_sink dev_src server

  vol=$(pamixer --get-volume 2>/dev/null)
  muted=$(pamixer --get-mute 2>/dev/null)

  if [[ "$muted" == "true" || "$vol" -eq 0 ]]; then
    icon=""
  elif (( vol <= 30 )); then
    icon=""
  elif (( vol <= 60 )); then
    icon=""
  else
    icon=""
  fi

  dev_sink=$(get_sink_info)
  dev_src=$(get_source_info)
  server=$(get_server_info)

  eww update \
    vol_lev="$vol" \
    vol_muted="$muted" \
    vol_dev="$dev_sink" \
    mic_dev="$dev_src" \
    sound_server="$server" 2>/dev/null

  echo "$icon"
}
# ---------------

# Microphone --------
mic_set () {
  local val="$1"
  (( val >= 0 && val <= 100 )) && pamixer --default-source --set-volume "$val"
}

mic_toggle () {
  pamixer --default-source -t
}

update_mic () {
  local mic_vol mic_muted icon dev_sink dev_src server

  mic_vol=$(pamixer --default-source --get-volume 2>/dev/null)
  mic_muted=$(pamixer --default-source --get-mute 2>/dev/null)

  if [[ "$mic_muted" == "true" || "$mic_vol" -eq 0 ]]; then
    icon=""
  else
    icon=""
  fi

  dev_sink=$(get_sink_info)
  dev_src=$(get_source_info)
  server=$(get_server_info)

  eww update \
    mic_lev="$mic_vol" \
    mic_muted="$mic_muted" \
    vol_dev="$dev_sink" \
    mic_dev="$dev_src" \
    sound_server="$server" 2>/dev/null

  echo "$icon"
}
# -------------------

# Listeners --------
listen_volume () {
  update_vol
  if command -v pactl &>/dev/null; then
    pactl subscribe 2>/dev/null | grep --line-buffered -E "sink|server" | while read -r _; do
      update_vol
    done
  else
    alsactl monitor 2>/dev/null | while read -r _; do
      update_vol
    done
  fi
}

listen_mic () {
  update_mic
  if command -v pactl &>/dev/null; then
    pactl subscribe 2>/dev/null | grep --line-buffered -E "source|server" | while read -r _; do
      update_mic
    done
  else
    alsactl monitor 2>/dev/null | while read -r _; do
      update_mic
    done
  fi
}
# ------------------

case "$1" in
  --set-volume)    vol_set "$2" ;;
  --toggle-volume) vol_toggle ;;
  --set-mic)       mic_set "$2" ;;
  --toggle-mic)    mic_toggle ;;
  --listen-volume) listen_volume ;;
  --listen-mic)    listen_mic ;;
  *)               update_vol ;;
esac