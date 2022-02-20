#!/bin/bash
MYDIR_STATE=`dirname $0`
DIR_STATE="`cd $MYDIR_STATE/../; pwd`"

. $DIR_STATE/multi_config.sh
. $DIR_STATE/example_config.sh
. $config_dir/telegram_config.conf
. $DIR_STATE/scripts/state_config.txt
. $DIR_TEL/scripts/actions.sh

method=$(grep -oP '(?<="method": ")[^"]*' $DIR_STATE/websocket_state.txt)
print_state_read=$(grep -oP '(?<="state": ")[^"]*' $DIR_STATE/websocket_state.txt)
shutdown="$1"

if [ "$method" = "notify_status_update" ]; then
	if [ "$print_state_read" = "printing" ]; then
        if [ "$print_state" = "0" ]; then
            sed -i "s/print_state=.*$/print_state="1"/g" $DIR_STATE/scripts/state_config.txt
            bash $DIR_STATE/scripts/telegram.sh "1"
            sleep 10
            if [ "$time" -gt "0" ]; then
            sed -i "s/time_pause=.*$/time_pause="0"/g" $DIR_STATE/scripts/time_config.txt
	        sed -i "s/time_msg=.*$/time_msg="1"/g" $DIR_STATE/scripts/time_config.txt
            bash $DIR_STATE/scripts/time_msg.sh &
            fi
        fi
        if [ "$pause" = "1" ]; then
            sed -i "s/pause=.*$/pause="0"/g" $DIR_STATE/scripts/state_config.txt
            sed -i "s/time_pause=.*$/time_pause="0"/g" $DIR_STATE/scripts/time_config.txt
        fi


    elif [ "$print_state_read" = "complete" ]; then
	    if [ "$print_state" = "1" ]; then
            sed -i "s/print_state=.*$/print_state="0"/g" $DIR_STATE/scripts/state_config.txt
            sed -i "s/time_msg=.*$/time_msg="0"/g" $DIR_STATE/scripts/time_config.txt
            bash $DIR_STATE/scripts/telegram.sh "2"
        fi

    elif [ "$print_state_read" = "paused" ]; then
        if [ "$print_state" = "1" ]; then
            if [ "$pause" = "0" ]; then
                timelapse="$(curl -H "X-Api-Key: $api_key" -s "http://127.0.0.1:$port/printer/objects/query?gcode_macro%20TIMELAPSE_TAKE_FRAME")"
                timelapse_pause=$(grep -oP '"is_paused": \K[^,]+'  <<< "$timelapse")
                if [ $timelapse_pause = "true" ]; then
                  exit 1
                else
                  sed -i "s/pause=.*$/pause="1"/g" $DIR_STATE/scripts/state_config.txt
                  sed -i "s/time_pause=.*$/time_pause="1"/g" $DIR_STATE/scripts/time_config.txt
                  bash $DIR_STATE/scripts/telegram.sh "3"
                fi
            fi
        fi     
    
    elif [ "$print_state_read" = "error" ]; then
        if [ "$print_state" = "1" ]; then
            sed -i "s/print_state=.*$/print_state="0"/g" $DIR_STATE/scripts/state_config.txt
            sed -i "s/time_pause=.*$/time_pause="0"/g" $DIR_STATE/scripts/time_config.txt
            sed -i "s/time_msg=.*$/time_msg="0"/g" $DIR_STATE/scripts/time_config.txt
            bash $DIR_STATE/scripts/telegram.sh "4"
        fi

    elif [ "$print_state_read" = "standby" ]; then
	    sed -i "s/print_state=.*$/print_state="0"/g" $DIR_STATE/scripts/state_config.txt
        sed -i "s/time_msg=.*$/time_msg="0"/g" $DIR_STATE/scripts/time_config.txt
        sed -i "s/time_pause=.*$/time_pause="0"/g" $DIR_STATE/scripts/time_config.txt

    elif [ "$shutdown" = "1" ]; then
	    sed -i "s/print_state=.*$/print_state="0"/g" $DIR_STATE/scripts/state_config.txt
        sed -i "s/time_msg=.*$/time_msg="0"/g" $DIR_STATE/scripts/time_config.txt
        sed -i "s/time_pause=.*$/time_pause="0"/g" $DIR_STATE/scripts/time_config.txt 
    fi
fi
exit 1