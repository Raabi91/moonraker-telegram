#!/bin/sh

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $DIR_TEL/example_config.sh
. $config_dir/telegram_config.sh
log=/tmp/$multi_instanz.log
date >> $log

take_picture()
{

  if curl --output /dev/null --silent --fail -r 0-0  "$webcam"; then

    if [ -n "${led_on}" ]; then
      curl -H "Content-Type: application/json" -X POST $led_on >> $log
      sleep $led_on_delay
    fi

   rm $DIR_TEL/picture/cam_new.jpg
   curl -m 20 -o $DIR_TEL/picture/cam_new.jpg $webcam >> $log

    if identify -format '%f' $DIR_TEL/picture/cam_new.jpg; then
  
     convert -rotate $rotate $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg

      if [ "$horizontally" = "1" ]; then
        convert -flop $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
      fi
      if [ "$vertically" = "1" ]; then
        convert -flip $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
      fi
        cam_link="$DIR_TEL/picture/cam_new.jpg"
    else
      echo Picture has an error >> $log
      cam_link="$DIR_TEL/picture/cam_error.jpg"
    fi
  
    if [ -n "${led_off}" ]; then
      sleep $led_off_delay
      curl -H "Content-Type: application/json" -X POST $led_off
    fi
  else
   echo Cam has an error >> $log
   cam_link="$DIR_TEL/picture/no_cam.jpg"
  fi
}


print=$(curl -s "http://127.0.0.1:$port/printer/objects/query?print_stats&display_status&extruder=target,temperature&heater_bed=target,temperature")
#### Filename ####
print_filename=$(echo "$print" | grep -oP '(?<="filename": ")[^"]*')
#### Print Duration ####
print_duration=$(echo "$print" | grep -oP '(?<="print_duration": )[^,]*')
#### Progress ####
progress=$(echo "$print" | grep -oP '(?<="progress": )[^,]*')
#### Print_state ####
print_state_read1=$(echo "$print" | grep -oP '(?<="state": ")[^"]*')
#### Extruder Temps ####
extruder=$(echo "$print" | grep -oP '(?<="extruder": {)[^}]*')
extruder_target=$(echo "$extruder" | grep -oP '(?<="target": )[^,]*')
extruder_temp1=$(echo "$extruder" | grep -oP '(?<="temperature": )[^,]*')
extruder_temp=$(printf %.2f $extruder_temp1)
#### Heater_Bed Temps ####
heater_bed=$(echo "$print" | grep -oP '(?<="heater_bed": {)[^}]*')
bed_target=$(echo "$heater_bed" | grep -oP '(?<="target": )[^,]*')
bed_temp1=$(echo "$heater_bed" | grep -oP '(?<="temperature": )[^,]*')
bed_temp=$(printf %.2f $bed_temp1)


#### Remaining to H M S ####
if [ "$print_duration" = "0.0" ]; then
 math2="0"
else
 math1=$(echo "scale=0; $print_duration/$progress" | bc -l)
 math2=$(echo "scale=0; $math1-$print_duration" | bc -l)
 echo $math1
 echo $math2
fi

remaining=$(printf "%.0f" $math2)
print_remaining=$(printf '%02d:%02d:%02d\n' $(($remaining/3600)) $(($remaining%3600/60)) $(($remaining%60)))

#### Current to H M S ####
current=$(printf "%.0f" $print_duration)
print_current=$(printf '%02d:%02d:%02d\n' $(($current/3600)) $(($current%3600/60)) $(($current%60)))

#### Progress to % ####
print_progress1=$(echo "scale=1; $progress*100" | bc )
print_progress=$(printf "%.1f" $print_progress1)%


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
  /gif send a 5 second gif"

       curl -s -X POST \
     ${tokenurl}/sendMessage \
     -d text="${msg}" \
     -d chat_id=${chatid}
     msg=""
else
    sh /home/pi/moonraker-telegram/scripts/telegram_custom.sh "$state_msg" "$custom_picture" &
    msg=""
fi


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
fi


exit 0