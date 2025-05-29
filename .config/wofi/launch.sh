#!/usr/bin/env bash
# Written by KalpaKavindu <kalpadevonline@gmail.com>

ps cax | grep wofi > /dev/null
if [ $? -eq 0 ]; then
  killall wofi
else
  uwsm app -- wofi &
fi