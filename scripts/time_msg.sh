#!/bin/bash

while true
do
. /home/pi/moonraker-telegram/telegram_config.sh

sleep $time

. /home/pi/moonraker-telegram/scripts/time_config.txt

	if [ "$time_msg" = "1" ]; then
        if [ "$time_pause" = "0" ]; then
        sh /home/pi/moonraker-telegram/scripts/telegram.sh "5"
        fi
    fi
    if [ "$time_msg" = "0" ]; then
        exit 0
    fi
done