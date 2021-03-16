#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $config_dir/telegram_config.sh

curl -s -o $DIR_TEL/telegram_stats.txt http://127.0.0.1:$port/printer/objects/query?print_stats
curl -s -o $DIR_TEL/display_status.txt http://127.0.0.1:$port/printer/objects/query?display_status

print_filename=$(grep -oP '(?<="filename": ")[^"]*' $DIR_TEL/telegram_stats.txt)
print_duration=$(grep -oP '(?<="print_duration": )[^,]*' $DIR_TEL/telegram_stats.txt)
progress=$(grep -oP '(?<="progress": )[^,]*' $DIR_TEL/display_status.txt)
print_state_read1=$(grep -oP '(?<="state": ")[^"]*' $DIR_TEL/websocket_state.txt)

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
        msg="hey, i'm idling, please let me print something"
    elif [ "$print_state_read1" = "complete" ]; then    
        msg="hey, i finished the last print now i am idling"
    elif [ "$print_state_read1" = "paused" ]; then    
        msg="hey, i'm on break, please take a look"
    elif [ "$print_state_read1" = "error" ]; then    
        msg="hey, i had a error. please look it up"
     fi
elif [ "$state_msg" = "6" ]; then
    msg="available commands are:
    /help
    /state
    /pause
    /resume
    /cancel"

       curl -s -X POST \
     ${tokenurl}/sendMessage \
     -d text="${msg}" \
     -d chat_id=${chatid}
     msg=""
else
  if [ "$custom_picture" = "1" ]; then
    msg="$state_msg"
    curl -s -o $DIR_TEL/picture/cam_new.jpg $webcam
    convert -rotate $rotate $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
    if [ "$horizontally" = "1" ]; then
      convert -flop $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
    fi
    if [ "$vertically" = "1" ]; then
      convert -flip $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
    fi
 
    curl -s -X POST \
      ${tokenurl}/sendPhoto \
      -F chat_id=${chatid} \
      -F photo="@$DIR_TEL/picture/cam_new.jpg" \
      -F caption="${msg}"
    msg=""
  else 
    msg="$state_msg"
    curl -s -X POST \
    ${tokenurl}/sendMessage \
    -d text="${msg}" \
    -d chat_id=${chatid}
    msg=""
  fi
fi

if [ -n "${msg}" ]; then
 if [ "$picture" = "1" ]; then
  curl -o $DIR_TEL/picture/cam_new.jpg $webcam

  convert -rotate $rotate $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg

  if [ "$horizontally" = "1" ]; then
    convert -flop $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
  fi
  if [ "$vertically" = "1" ]; then
    convert -flip $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
  fi
 
  curl -s -X POST \
    ${tokenurl}/sendPhoto \
    -F chat_id=${chatid} \
    -F photo="@$DIR_TEL/picture/cam_new.jpg" \
    -F caption="${msg}"

 elif [ "$picture" = "0" ]; then

   curl -s -X POST \
     ${tokenurl}/sendMessage \
     -d text="${msg}" \
     -d chat_id=${chatid}

 fi
fi


exit 0