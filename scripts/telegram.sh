#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. "$DIR_TEL/multi_config.sh"
. "$DIR_TEL/example_config.sh"
. "$config_dir/telegram_config.conf"
. "$DIR_TEL/scripts/actions.sh"
echo "telegram.sh" >> "$log/$multi_instanz.log"

create_variables

. "$config_dir/telegram_config.conf"

tokenurl="https://api.telegram.org/bot$token"
state_msg="$1"
custom_picture="$2"
gif_enable=0

if [ "$state_msg" = "1" ]; then
    msg="$msg_start"
    if [ "$pic_start" = "0" ]; then
        picture="0"
        gif="0"
    fi
    sleep $delay_start_msg

elif [ "$state_msg" = "2" ]; then
    msg="$msg_end"
    if [ "$pic_end" = "0" ]; then
        picture="0"
        gif="0"
    fi
    sleep $delay_end_msg

elif [ "$state_msg" = "3" ]; then
    msg="$msg_pause"
    if [ "$pic_pause" = "0" ]; then
        picture="0"
        gif="0"
    fi
    sleep $delay_pause_msg

elif [ "$state_msg" = "4" ]; then
    msg="$msg_error"
    if [ "$pic_error" = "0" ]; then
        picture="0"
        gif="0"
    fi

elif [ "$state_msg" = "5" ]; then
    if [ "$print_state_read1" = "printing" ]; then
        msg="$msg_state"
        if [ "$pic_state" = "0" ]; then
            picture="0"
            gif="0"
        fi
        if [ "$gif" = "1" ]; then
            gif_enable="1"
        fi
    elif [ "$print_state_read1" = "standby" ]; then
        msg="$msg_standby"
        if [ "$pic_standby" = "0" ]; then
            picture="0"
            gif="0"
        fi
    elif [ "$print_state_read1" = "complete" ]; then
        msg="$msg_complete"
        if [ "$pic_complete" = "0" ]; then
            picture="0"
            gif="0"
        fi
    elif [ "$print_state_read1" = "paused" ]; then
        msg="$msg_paused"
        if [ "$pic_paused" = "0" ]; then
            picture="0"
            gif="0"
        fi
    elif [ "$print_state_read1" = "error" ]; then
        msg="$msg_error"
        if [ "$pic_error" = "0" ]; then
            picture="0"
            gif="0"
        fi
    fi
elif [ "$state_msg" = "6" ]; then
    msg="Available commands are:
  --------------------------------------------
/state - Current status including a photo
/pause - Pause current print. A confirmation will be requested
/resume - Resume current print.
/cancel - Abort the current print. A confirmation will be requested
/help - Show list of commands.
/print - Select a file from moonraker for printing
/power - Interact with power devices of moonraker
/gcode_macro - Run custom GCode Macros of moonraker
/gif - Send a 5 second gif
/host - Restart Firmware or Klipper and reboot and shutdown of the Host
/timelapse - download files from timelpase plugin by selection
  --------------------------------------------  
you have further questions then please look first in the Faq:
https://github.com/Raabi91/moonraker-telegram/blob/master/docs/FAQ.md"

    curl -s -X POST \
        ${tokenurl}/sendMessage \
        -d text="${msg}" \
        -d chat_id="${chatid}"
    msg=""

elif [ "$state_msg" = "7" ]; then
    msg="$msg_bed_cooldown"
    if [ "$pic_bed_cooldown" = "0" ]; then
        picture="0"
        gif="0"
    fi

else
    if [ "$custom_picture" = "1" ]; then
        rm $DIR_TEL/picture/cam_new*.jpg
        light_on
        array=0
        for item in ${webcam[*]}
        do
            take_picture
            array=$((array+1))
        done
        light_off
        msg="$state_msg"
        picture_number=0
        webcams=$(echo "${#webcam[@]}")
        if [ "$webcams" == "1" ]; then
          for filename in $DIR_TEL/picture/cam_new*; do
            if [ "$picture_number" == "0" ]; then
              curl -s -X POST \
                  ${tokenurl}/sendPhoto \
                  -F chat_id="${chatid}" \
                  -F photo="@$filename" \
                  -F caption="${msg}"
            fi
            picture_number=$((picture_number+1))
            sleep 0.1
          done
        elif [ "$webcams" != "1" ]; then
          for filename in $DIR_TEL/picture/cam_new*; do            
              if [ "$picture_number" == "0" ]; then
                  media='{"type":"photo","media":"attach://photo_'$picture_number'"}' 
                  photos="photo_$picture_number=@$filename"
              elif [ "$picture_number" != "0" ]; then
                  media=$media',{"type":"photo","media":"attach://photo_'$picture_number'"}'
                  photos="$photos -F photo_$picture_number=@$filename"
              fi
            picture_number=$((picture_number+1))
            sleep 0.1
          done 
            if [ "$msg" != "" ]; then 
              curl -s -X POST \
                ${tokenurl}/sendMediaGroup \
                -F chat_id="${chatid}" \
                -F media='['$media']' \
                -F disable_notification="true" \
                -F $photos
              curl -s -X POST \
                ${tokenurl}/sendMessage \
                -d text="${msg}" \
                -d chat_id="${chatid}"
            else 
              curl -s -X POST \
                ${tokenurl}/sendMediaGroup \
                -F chat_id="${chatid}" \
                -F media='['$media']' \
                -F $photos
            fi   
        fi 
                
        rm $DIR_TEL/picture/cam_new*.jpg
    else
        msg="$state_msg"
        curl -s -X POST \
            ${tokenurl}/sendMessage \
            -d text="${msg}" \
            -d chat_id="${chatid}"
    fi
    echo "Send MSG = $msg" >> "$log/$multi_instanz.log"
    exit 0
fi

if [[ -n "${msg}" ]]; then
    if [ "$picture" = "1" ]; then
        rm $DIR_TEL/picture/cam_new*.jpg
        light_on
        array=0
        for item in ${webcam[*]}
        do
            take_picture
            array=$((array+1))
        done
        light_off

        picture_number=0
        webcams=$(echo "${#webcam[@]}")
        if [ "$webcams" == "1" ]; then
          for filename in $DIR_TEL/picture/cam_new*; do
            if [ "$picture_number" == "0" ]; then
              curl -s -X POST \
                  ${tokenurl}/sendPhoto \
                  -F chat_id="${chatid}" \
                  -F photo="@$filename" \
                  -F caption="${msg}"
            fi
            picture_number=$((picture_number+1))
            sleep 0.1
          done
        elif [ "$webcams" != "1" ]; then
          for filename in $DIR_TEL/picture/cam_new*; do            
              if [ "$picture_number" == "0" ]; then
                  media='{"type":"photo","media":"attach://photo_'$picture_number'"}' 
                  photos="photo_$picture_number=@$filename"
              elif [ "$picture_number" != "0" ]; then
                  media=$media',{"type":"photo","media":"attach://photo_'$picture_number'"}'
                  photos="$photos -F photo_$picture_number=@$filename"
              fi
            picture_number=$((picture_number+1))
            sleep 0.1
          done 
              curl -s -X POST \
                ${tokenurl}/sendMediaGroup \
                -F chat_id="${chatid}" \
                -F media='['$media']' \
                -F disable_notification="true" \
                -F $photos
              curl -s -X POST \
                ${tokenurl}/sendMessage \
                -d text="${msg}" \
                -d chat_id="${chatid}"
        fi 
                
        rm $DIR_TEL/picture/cam_new*.jpg
        
    elif [ "$picture" = "0" ]; then

        curl -s -X POST \
            ${tokenurl}/sendMessage \
            -d text="${msg}" \
            -d chat_id="${chatid}"

    fi
    echo "Send MSG = $msg" >> "$log/$multi_instanz.log"
    if [ "$gif_enable" = "1" ]; then
        bash "$DIR_TEL/scripts/gif.sh"
    fi

fi


exit 0
