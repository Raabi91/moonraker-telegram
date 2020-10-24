#!/bin/bash
. /home/pi/moonraker-telegram/telegram_config.sh

echo "time_msg=0" > /home/pi/moonraker-telegram/scripts/time_config.txt
echo "time_pause=0" >> /home/pi/moonraker-telegram/scripts/time_config.txt

print_state="0"
pause="0"

while true
do

curl -s -o print_stats.txt http://127.0.0.1:$port/printer/objects/query?print_stats
print_state_read=$(grep -oP '(?<="state": ")[^"]*' print_stats.txt)

	if [ "$print_state_read" = "printing" ]; then
        if [ "$print_state" = "0" ]; then
            print_state="1"
            sh /home/pi/moonraker-telegram/scripts/telegram.sh "1"
            sleep 10
            if [ "$time" > "0" ]; then
            sed -i "s/time_pause=.*$/time_pause="0"/g" /home/pi/moonraker-telegram/scripts/time_config.txt
	        sed -i "s/time_msg=.*$/time_msg="1"/g" /home/pi/moonraker-telegram/scripts/time_config.txt
            sh /home/pi/moonraker-telegram/scripts/time_msg.sh &
            fi
        fi
        if [ "$pause" = "1" ]; then
            pause="0"
            sed -i "s/time_pause=.*$/time_pause="0"/g" /home/pi/moonraker-telegram/scripts/time_config.txt
        fi


    elif [ "$print_state_read" = "complete" ]; then
	    if [ "$print_state" = "1" ]; then
            print_state="0"
            sed -i "s/time_msg=.*$/time_msg="0"/g" /home/pi/moonraker-telegram/scripts/time_config.txt
            sh /home/pi/moonraker-telegram/scripts/telegram.sh "2"
        fi

    elif [ "$print_state_read" = "paused" ]; then
        if [ "$print_state" = "1" ]; then
            if [ "$pause" = "0" ]; then
            pause="1"
            sed -i "s/time_pause=.*$/time_pause="1"/g" /home/pi/moonraker-telegram/scripts/time_config.txt
            sh /home/pi/moonraker-telegram/scripts/telegram.sh "3"
            fi
        fi     
    
    elif [ "$print_state_read" = "error" ]; then
        if [ "$print_state" = "1" ]; then
            print_state="0"
            sed -i "s/time_msg=.*$/time_msg="0"/g" /home/pi/moonraker-telegram/scripts/time_config.txt
            sh /home/pi/moonraker-telegram/scripts/telegram.sh "4"
        fi

    elif [ "$print_state_read" = "standby" ]; then
	    print_state="0"
        sed -i "s/time_msg=.*$/time_msg="0"/g" /home/pi/moonraker-telegram/scripts/time_config.txt
        sed -i "s/time_pause=.*$/time_pause="0"/g" /home/pi/moonraker-telegram/scripts/time_config.txt
    fi


sleep 1
done