#!/bin/bash

curl -s -o telegram_stats.txt http://127.0.0.1:$port/printer/objects/query?print_stats
print_filename=$(grep -oP '(?<="filename": ")[^"]*' print_stats.txt)

. /home/pi/moonraker-telegram/telegram_config.sh

tokenurl="https://api.telegram.org/bot$token"
state_msg="$1"

if [ "$state_msg" = "1" ]; then
    msg="$msg_start"

elif [ "$state_msg" = "2" ]; then
    msg="$msg_end"

elif [ "$state_msg" = "2" ]; then
    msg="$msg_pause"

elif [ "$state_msg" = "2" ]; then
    msg="$msg_error"
fi

if [ "$picture" = "1" ]; then
  wget -O /home/pi/moonraker-telegram/picture/cam_new.jpg $webcam

  convert -rotate $rotate /home/pi/moonraker-telegram/picture/cam_new.jpg /home/pi/moonraker-telegram/picture/cam_new.jpg

  if [ "$horizontally" = "1" ]; then
    convert -flop /home/pi/moonraker-telegram/picture/cam_new.jpg /home/pi/moonraker-telegram/picture/cam_new.jpg
  fi
  if [ "$vertically" = "1" ]; then
    convert -flop /home/pi/moonraker-telegram/picture/cam_new.jpg /home/pi/moonraker-telegram/picture/cam_new.jpg
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

exit