#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

toggle_bar () {
  x=$(eww active-windows | grep -w 'statusbar' | awk '{print $2}')
  if [[ "$x" == "statusbar" ]]; then
    eww close statusbar
  else
    eww open statusbar
  fi
}

launch_bar () {
  killall eww
  uwsm app -- eww daemon
  eww open statusbar
}

case $1 in
  --launch-bar) launch_bar ;;
  --toggle-bar) toggle_bar ;;
esac