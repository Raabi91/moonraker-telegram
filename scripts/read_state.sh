#!/bin/bash
. /home/pi/moonraker-telegram/telegram_config.sh

print_state="0"

while true
do

curl -s -o print_stats.txt http://127.0.0.1:$port/printer/objects/query?print_stats
print_state_read=$(grep -oP '(?<="state": ")[^"]*' print_stats.txt)
print_filename=$(grep -oP '(?<="filename": ")[^"]*' print_stats.txt)

	if [ "$print_state_read" = "printing" ]; then
        if [ "$print_state" = "0" ]; then
            msg="$msg_start"
            print_state="1"
            sh /home/pi/moonraker-telegram/scripts/telegram.sh
        fi

    elif [ "$print_state_read" = "complete" ]; then
	    if [ "$print_state" = "1" ]; then
            msg="$msg_end"
            print_state="0"
            sh /home/pi/moonraker-telegram/scripts/telegram.sh
        fi

    elif [ "$print_state_read" = "paused" ]; then
        if [ "$print_state" = "1" ]; then
            msg="$msg_pause"
            sh /home/pi/moonraker-telegram/scripts/telegram.sh
        fi
    
    elif [ "$print_state_read" = "error" ]; then
        if [ "$print_state" = "1" ]; then
	        msg="$msg_error"
            print_state="0"
            sh /home/pi/moonraker-telegram/scripts/telegram.sh
        fi

    elif [ "$print_state_read" = "standby"]; then
	print_state="0"
    fi


sleep 5
done