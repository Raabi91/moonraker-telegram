#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $DIR_TEL/example_config.sh
. $config_dir/telegram_config.conf

take_picture()
{
  curl -o $DIR_TEL/picture/gif/$picture_gif.jpg $webcam

  convert -quiet -rotate $rotate $DIR_TEL/picture/gif/$picture_gif.jpg $DIR_TEL/picture/gif/$picture_gif.jpg

  if [ "$horizontally" = "1" ]; then
    convert -quiet -flop $DIR_TEL/picture/gif/$picture_gif.jpg $DIR_TEL/picture/gif/$picture_gif.jpg
  fi
  if [ "$vertically" = "1" ]; then
    convert -quiet -flip $DIR_TEL/picture/gif/$picture_gif.jpg $DIR_TEL/picture/gif/$picture_gif.jpg
  fi
}

 if [ -n "${led_on}" ]; then
    curl -H "Content-Type: application/json" -X POST $led_on
    sleep $led_on_delay
 fi
picture_gif=01
take_picture
sleep 0.5
picture_gif=02
take_picture
sleep 0.5
picture_gif=03
take_picture
sleep 0.5
picture_gif=04
take_picture
sleep 0.5
picture_gif=05
take_picture
sleep 0.5
picture_gif=06
take_picture
sleep 0.5
picture_gif=07
take_picture
sleep 0.5
picture_gif=08
take_picture
sleep 0.5
picture_gif=09
take_picture
sleep 0.5
picture_gif=10
take_picture

 if [ -n "${led_off}" ]; then
    sleep $led_off_delay
    curl -H "Content-Type: application/json" -X POST $led_off
 fi

convert -quiet -resize 768x576 -delay 20 -loop 0 $DIR_TEL/picture/gif/*.jpg $DIR_TEL/picture/5sec.gif

rm -r $DIR_TEL/picture/gif/*.jpg 

. $config_dir/telegram_config.conf

tokenurl="https://api.telegram.org/bot$token"

## Send Gif

    msg=""
    curl -s -X POST \
      ${tokenurl}/sendAnimation \
      -F chat_id=${chatid} \
      -F animation="@$DIR_TEL/picture/5sec.gif" \
      -F caption="${msg}"
    msg=""

exit 0