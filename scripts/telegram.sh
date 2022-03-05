#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $DIR_TEL/example_config.sh
. $config_dir/telegram_config.conf
. $DIR_TEL/scripts/actions.sh
echo "telegram.sh" >> $log

create_varibales

. $config_dir/telegram_config.conf

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
    msg="available commands are:
  /state - Sends the current status including a current photo.
  /pause - Pause current Print.  A confirmation is required
  /resume - resume current Print.
  /cancel - Aborts the currently running print. A confirmation is required
  /help - show list of commands.
  /print - Will open a file dialog showing the files stored in moonraker. You can select a file to print it.
  /power - Will open a file dialog showing the Power devices of moonraker. You can choose a device to interact with it
  /gcode_macro - Will open a file dialog showing the custom Gcode_macros of the printer.cfg. You can choose a macro to execute it
  /gif - send a 5 second gif"

       curl -s -X POST \
     ${tokenurl}/sendMessage \
     -d text="${msg}" \
     -d chat_id=${chatid}
     msg=""

elif [ "$state_msg" = "7" ]; then
    msg="$msg_bed_cooldown"
    if [ "$pic_bed_cooldown" = "0" ]; then
     picture="0"
     gif="0"
    fi

else
  if [ "$custom_picture" = "1" ]; then
    msg="$state_msg"
    take_picture
    curl -s -X POST \
      ${tokenurl}/sendPhoto \
      -F chat_id=${chatid} \
      -F photo="@$cam_link" \
      -F caption="${msg}"
  else
    msg="$state_msg"
    curl -s -X POST \
      ${tokenurl}/sendMessage \
      -d text="${msg}" \
      -d chat_id=${chatid}
  fi
  echo "Send MSG = $msg" >> $log
  exit 0
fi

if [[ -n "${msg}" ]]; then
 if [ "$picture" = "1" ]; then

  light_on
  array=0
  for item in ${webcam[*]}
  do
    take_picture
    array=$((array+1))
  done
  light_off

  picture_number=0
  for filename in $DIR_TEL/picture/cam_new*; do
    if [ "$picture_number" == "0" ]; then
      curl -s -X POST \
        ${tokenurl}/sendPhoto \
        -F chat_id=${chatid} \
        -F photo="@$filename" \
        -F caption="${msg}"
    elif [ "$picture_number" != "0" ]; then
      curl -s -X POST \
        ${tokenurl}/sendPhoto \
        -F chat_id=${chatid} \
        -F photo="@$filename"
    fi
    picture_number=$((picture_number+1))
    sleep 0.1
  done

 elif [ "$picture" = "0" ]; then

   curl -s -X POST \
     ${tokenurl}/sendMessage \
     -d text="${msg}" \
     -d chat_id=${chatid}

 fi
 echo "Send MSG = $msg" >> $log
  if [ "$gif_enable" = "1" ]; then
    bash $DIR_TEL/scripts/gif.sh
  fi

fi


exit 0
