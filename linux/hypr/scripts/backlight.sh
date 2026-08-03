#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

# Get brightness
get_backlight() {
	echo $(printf "%.0f\n" $(brightnessctl g))
}

# Notify
notify_user() {
	eww open brightness_notifier --duration 5s
}

# Increase brightness
inc_backlight() {
	brightnessctl s +2% && notify_user
}

# Decrease brightness
dec_backlight() {
	current="$(get_backlight)"
	if [ "$current" -ge "8" ]; then
		brightnessctl s 2%- && notify_user
	fi
}

case $1 in 
 --inc) inc_backlight ;;
 --dec) dec_backlight ;;
esac