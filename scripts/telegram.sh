#!/bin/bash
. /home/pi/moonraker-telegram/telegram_config.sh

tokenurl="https://api.telegram.org/bot$token"
msg="$1"

if [ "$picture" = "1" ]; then
  wget -O /home/pi/moonraker-telegram/picture/cam_new.jpg $webcam
  curl -s -X POST \
    ${tokenurl}/sendPhoto \
    -F chat_id=${chatid} \
    -F photo="@/home/pi/moonraker-telegram/picture/cam_new.jpg" \
    -F caption="$msg"

elif [ "$picture" = "0" ]; then

   curl -s -X POST \
     ${tokenurl}/sendMessage \
     -d text="$msg" \
     -d chat_id=${chatid}

fi

exit