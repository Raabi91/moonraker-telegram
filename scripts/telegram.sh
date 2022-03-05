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
    sleep $delay_start_msg

elif [ "$state_msg" = "2" ]; then
    msg="$msg_end"
    sleep $delay_end_msg

elif [ "$state_msg" = "3" ]; then
    msg="$msg_pause"
    sleep $delay_pause_msg

elif [ "$state_msg" = "4" ]; then
    msg="$msg_error"

elif [ "$state_msg" = "5" ]; then
    if [ "$print_state_read1" = "printing" ]; then    
        msg="$msg_state"
          if [ "$gif" = "1" ]; then
            gif_enable="1"
          fi
    elif [ "$print_state_read1" = "standby" ]; then    
        msg="$msg_standby"
    elif [ "$print_state_read1" = "complete" ]; then    
        msg="$msg_complete"
    elif [ "$print_state_read1" = "paused" ]; then    
        msg="$msg_paused"
    elif [ "$print_state_read1" = "error" ]; then    
        msg="$msg_error"
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



if [ -n "${msg}" ]; then
 echo "msg vorhanden"
 if [ "$picture" = "1" ]; then
  
  light_on
  echo "light on"
  array=0
  echo "Array items:"
  for item in ${webcam[*]}
  do
    echo "generate picture$array"
    take_picture
    array=$((array+1))
  done
  echo "light_off"
  light_off

  picture_number=1
  for filename in $DIR_TEL/picture/cam_new*; do
    if [ "$picture_number" -gt "1" ]; then
      echo "send picture$picture_number"
      curl -s -X POST \
        ${tokenurl}/sendPhoto \
        -F chat_id=${chatid} \
        -F photo="@$filename" \
    else
      echo "send msg"
      curl -s -X POST \
        ${tokenurl}/sendPhoto \
        -F chat_id=${chatid} \
        -F photo="@$filename" \
        -F caption="${msg}"
    fi
    picture_number=$((picture_number+1))
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

echo "ende"

exit 0