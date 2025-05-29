#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

vol_get () {
	x=$(pamixer --get-volume)
	eww update vol_lev="$x"
}

mic_get () {
	x=$(pamixer --default-source --get-volume)
	eww update mic_lev="$x"
}

vol_muted () {
	x=$(pamixer --get-mute)
	eww update vol_muted="$x"
}

mic_muted () {
	x=$(pamixer --default-source --get-mute)
	eww update mic_muted="$x"
}

vol_icon () {
	if [[ "$(pamixer --get-mute)" == "false" ]]; then
		current=$(pamixer --get-volume)
		if [[ "$current" -eq "0" ]]; then
			echo ""
		elif [[ "$current" -le "30" ]]; then
			echo ""
		elif [[ "$current" -le "60" ]]; then
			echo ""
		elif [[ "$current" -le "100" ]]; then
			echo ""
		fi
	else
		echo ""
	fi
}

mic_icon () {
	if [[ "$(pamixer --default-source --get-mute)" == "false" ]]; then
		current=$(pamixer --default-source --get-volume)
		if [[ "$current" -eq "0" ]]; then
			echo ""
		else
			echo ""
		fi
	else
		echo ""
	fi
}

vol_set () {
	if [[ ("$1" -ge "0") && ("$1" -le "100") ]]; then
		pamixer --set-volume "$1"
	fi
}

mic_set () {
	if [[ ("$1" -ge "0") && ("$1" -le "100") ]]; then
		pamixer --default-source --set-volume "$1"
	fi
}

vol_toggle () {
	if [[ "$(pamixer --get-mute)" == "false" ]]; then
		pamixer -m
	else
		pamixer -u
	fi
}

mic_toggle() {
	if [[ "$(pamixer --default-source --get-mute)" == "false" ]]; then
		pamixer --default-source -m
	else
		pamixer --default-source -u
	fi
}

case $1 in
	--set-volume) vol_set "$2" ;;
	--toggle-volume) vol_toggle ;;
	--set-mic) mic_set "$2" ;;
	--toggle-mic) mic_toggle ;;
esac

if [[ "$1" == "--listen-volume" ]]; then
	vol_get
	vol_icon 
	vol_muted

	alsactl monitor | while read -r _; do
		vol_get
		vol_icon
		vol_muted
	done
fi

if [[ "$1" == "--listen-mic" ]]; then
	mic_get
	mic_icon
	mic_muted

	alsactl monitor | while read -r _; do
		mic_get
		mic_icon
		mic_muted
	done
fi