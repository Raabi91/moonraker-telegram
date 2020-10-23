#!/bin/bash
. /home/pi/moonraker-telegram/telegram_config.sh

print_state="0"
pause="0"

while true
do

curl -s -o print_stats.txt http://127.0.0.1:$port/printer/objects/query?print_stats
print_state_read=$(grep -oP '(?<="state": ")[^"]*' print_stats.txt)
print_filename=$(grep -oP '(?<="filename": ")[^"]*' print_stats.txt)

	if [ "$print_state_read" = "printing" ]; then
        if [ "$print_state" = "0" ]; then
            print_state="1"
            sh /home/pi/moonraker-telegram/scripts/telegram.sh $msg_start
        fi
        if [ "$pause" = "1" ]; then
            pause="0"
        fi


    elif [ "$print_state_read" = "complete" ]; then
	    if [ "$print_state" = "1" ]; then
            print_state="0"
            sh /home/pi/moonraker-telegram/scripts/telegram.sh $msg_end
        fi

    elif [ "$print_state_read" = "paused" ]; then
        if [ "$print_state" = "1" ]; then
            if [ "$pause" = "0" ]; then
            pause="1"
            sh /home/pi/moonraker-telegram/scripts/telegram.sh $msg_pause
            fi
        fi     
    
    elif [ "$print_state_read" = "error" ]; then
        if [ "$print_state" = "1" ]; then
            print_state="0"
            sh /home/pi/moonraker-telegram/scripts/telegram.sh $msg_error
        fi

    elif [ "$print_state_read" = "standby"]; then
	print_state="0"
    fi


sleep 1
done