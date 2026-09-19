#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

apply_profile_hooks () {
  local mode="$1"
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  case "$mode" in
    power-saver)
      # Lower screen brightness. Don't use this unless you want crappy control on statusbar.
      # brightnessctl set 25% 

      # Disable Hyprland animations & blur
      hyprctl eval 'hl.config({ decoration = { blur = { enabled = false } } })' &> /dev/null
      hyprctl eval 'hl.config({ animations = { enabled = false } })' &> /dev/null

      # Reduce refresh rate to 60Hz
      # hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "auto", scale = 1 })' &> /dev/null
      $SCRIPT_DIR/backlight.sh --set-rr 60
      ;;

    balanced)
      # Restore standard brightness. Don't use this unless you want crappy control on statusbar.
      # brightnessctl set 50%

      # Re-enable Hyprland animations & blur
      hyprctl eval 'hl.config({ decoration = { blur = { enabled = true } } })' &> /dev/null
      hyprctl eval 'hl.config({ animations = { enabled = true } })' &> /dev/null

      # Reduce refresh rate to 60Hz
      # hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "auto", scale = 1 })' &> /dev/null
      $SCRIPT_DIR/backlight.sh --set-rr 60
      ;;

    performance)
      # High brightness. Don't use this unless you want crappy control on statusbar.
      # brightnessctl set 80%

      # Re-enable animations & blur
      hyprctl eval 'hl.config({ decoration = { blur = { enabled = true } } })' &> /dev/null
      hyprctl eval 'hl.config({ animations = { enabled = true } })' &> /dev/null

      # Enable maximum refresh rate
      # hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "auto", scale = 1 })' &> /dev/null
      $SCRIPT_DIR/backlight.sh --set-rr 144
      ;;
  esac
}


get_profile () {
  powerprofilesctl get 2>/dev/null || echo "balanced"
}

get_profile_name () {
  case "$(get_profile)" in
    power-saver) echo "Power saver" ;;
    balanced)    echo "Balanced" ;;
    performance) echo "Best performance" ;;
    *)           echo "Balanced" ;;
  esac
}

update_eww () {
  local name mode
  # mode=$(get_profile)
  name=$(get_profile_name)

  # eww update power_mode="$mode" 2>/dev/null
  eww update power_mode_name="$name" 2>/dev/null
}

set_profile () {
  local target="$1"

  case "$target" in
    saver|power-saver) mode="power-saver" ;;
    balanced)          mode="balanced" ;;
    performance|perf)  mode="performance" ;;
    *) return 1 ;;
  esac

  powerprofilesctl set "$mode" 2>/dev/null
  apply_profile_hooks "$mode"
  update_eww
}

listen_profile () {
  update_eww
  if command -v dbus-monitor &>/dev/null; then
    dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='org.freedesktop.UPower.PowerProfiles'" 2>/dev/null | while read -r _; do
      local mode
      mode=$(get_profile)
      apply_profile_hooks "$mode"
      update_eww
      echo "$mode"
    done
  else
    while true; do
      sleep 3

      local mode
      mode=$(get_profile)
      apply_profile_hooks "$mode"
      update_eww
      echo "$mode"
    done
  fi
}

case "$1" in
  --set)    set_profile "$2" ;;
  --listen) listen_profile ;;
  *)        update_eww ;;
esac