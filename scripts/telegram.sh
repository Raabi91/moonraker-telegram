#!/bin/bash

curl -s -o telegram_stats.txt http://127.0.0.1:$port/printer/objects/query?print_stats
curl -s -o display_status.txt http://127.0.0.1:$port/printer/objects/query?display_status

print_filename=$(grep -oP '(?<="filename": ")[^"]*' print_stats.txt)
print_duration=$(grep -oP '(?<="print_duration": ")[^"]*' print_stats.txt)
progress=$(grep -oP '(?<="progress": ")[^"]*' display_status.txt)

#### Remaining to H M S ####
if [ "$print_duration" > "0" ]; then
math1=$(echo "scale=0; $print_duration/$progress" | bc -l)
math2=$(echo "scale=0; $math1-$print_duration" | bc -l)
else
math2="0"
fi
remaining=$(printf "%.0f" $math2)
print_remaining=$(printf '%dh:%dm:%ds\n' $(($remaining/3600)) $(($remaining%3600/60)) $(($remaining%60)))

#### Current to H M S ####
current=$(printf "%.0f" $print_duration)
print_current=$(printf '%dh:%dm:%ds\n' $(($current/3600)) $(($current%3600/60)) $(($current%60)))

#### Progress to % ####
print_progress1=$(echo "scale=1; $progress*100" | bc )
print_progress=$(printf "%.1f" $print_progress1)%


. /home/pi/moonraker-telegram/telegram_config.sh

tokenurl="https://api.telegram.org/bot$token"
state_msg="$1"

if [ "$state_msg" = "1" ]; then
    msg="$msg_start"

elif [ "$state_msg" = "2" ]; then
    msg="$msg_end"

elif [ "$state_msg" = "3" ]; then
    msg="$msg_pause"

elif [ "$state_msg" = "4" ]; then
    msg="$msg_error"

elif [ "$state_msg" = "5" ]; then
    msg="$msg_state"
fi

if [ "$picture" = "1" ]; then
  wget -O /home/pi/moonraker-telegram/picture/cam_new.jpg $webcam

  convert -rotate $rotate /home/pi/moonraker-telegram/picture/cam_new.jpg /home/pi/moonraker-telegram/picture/cam_new.jpg

  if [ "$horizontally" = "1" ]; then
    convert -flop /home/pi/moonraker-telegram/picture/cam_new.jpg /home/pi/moonraker-telegram/picture/cam_new.jpg
  fi
  if [ "$vertically" = "1" ]; then
    convert -flip /home/pi/moonraker-telegram/picture/cam_new.jpg /home/pi/moonraker-telegram/picture/cam_new.jpg
  fi
 
  curl -s -X POST \
    ${tokenurl}/sendPhoto \
    -F chat_id=${chatid} \
    -F photo="@/home/pi/moonraker-telegram/picture/cam_new.jpg" \
    -F caption="${msg}"

elif [ "$picture" = "0" ]; then

   curl -s -X POST \
     ${tokenurl}/sendMessage \
     -d text="${msg}" \
     -d chat_id=${chatid}

fi

exit 0