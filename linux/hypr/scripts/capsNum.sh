#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

C=$(cat /sys/class/leds/*::capslock/brightness 2>/dev/null | head -n 1);
N=$(cat /sys/class/leds/*::numlock/brightness 2>/dev/null | head -n 1);

get_txt(){
    if [ "$C" = "1" ] && [ "$N" = "1" ]; then 
        echo "<span color=\"#C54764\">Caps Lock and Num Lock ON</span>";
    elif [ "$C" = "1" ]; then 
        echo "<span color=\"#EF9872\">Caps Lock ON</span>";
    elif [ "$N" = "1" ]; then
        echo "<span color=\"#B36E8F\">Num Lock ON</span>";
     else
        echo "";
    fi
}

get_col(){
    if [ "$C" = "1" ] && [ "$N" = "1" ]; then 
    echo "rgba(C54764FF)";
elif [ "$C" = "1" ]; then 
    echo "rgba(EF9872FF)";
elif [ "$N" = "1" ]; then
    echo "rgba(574F87FF)";
 else
    echo "rgba(2BA6C5ff)";
fi
}

case $1 in
    --txt) counter ;get_txt ;;
    --col) counter ;get_col ;;
esac