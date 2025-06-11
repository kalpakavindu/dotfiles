#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

# Notify
notify_user() {
	eww open volume_notifier --duration 5s
}

# Increase Volume
inc_volume() {
	pamixer -i 2 && notify_user
}

# Decrease Volume
dec_volume() {
	pamixer -d 2 && notify_user
}

# Toggle Mute
toggle_mute() {
	if [ "$(pamixer --get-mute)" == "false" ]; then
		pamixer -m && notify_user
	elif [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -u && notify_user
	fi
}

case $1 in
 --inc) inc_volume ;;
 --dec) dec_volume ;;
 --toggle) toggle_mute ;;
esac
