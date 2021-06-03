#!/bin/sh

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $DIR_TEL/example_config.sh
. $config_dir/telegram_config.sh
. $DIR_TEL/scripts/actions.sh
log=/tmp/$multi_instanz.log
echo "$(date) : telegram.sh" >> $log

create_varibales

. $config_dir/telegram_config.sh

tokenurl="https://api.telegram.org/bot$token"
state_msg="$1"
custom_picture="$2"

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
else
  #sh /home/pi/moonraker-telegram/scripts/telegram_custom.sh "$state_msg" "$custom_picture"
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
  echo "$(date) : Send MSG = $msg" >> $log
  exit 0
fi

create_varibales

if [ -n "${msg}" ]; then
 if [ "$picture" = "1" ]; then

  take_picture
 
  curl -s -X POST \
    ${tokenurl}/sendPhoto \
    -F chat_id=${chatid} \
    -F photo="@$cam_link" \
    -F caption="${msg}"

 elif [ "$picture" = "0" ]; then

   curl -s -X POST \
     ${tokenurl}/sendMessage \
     -d text="${msg}" \
     -d chat_id=${chatid}

 fi
 echo "$(date) : Send MSG = $msg" >> $log
fi


exit 0