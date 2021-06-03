#!/bin/sh

take_picture()
{

  if curl --output /dev/null --silent --fail -r 0-0  "$webcam"; then
    echo "$(date) : Webcam link is working" >> $log

    if [ -n "${led_on}" ]; then
      echo "$(date) : Led on" >> $log
      curl -H "Content-Type: application/json" -X POST $led_on
      sleep $led_on_delay
    fi

   rm $DIR_TEL/picture/cam_new.jpg
   curl -m 20 -o $DIR_TEL/picture/cam_new.jpg $webcam

    if identify -format '%f' $DIR_TEL/picture/cam_new.jpg; then
      echo "$(date) : Jpeg file is okay" >> $log
  
     convert -rotate $rotate $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg

      if [ "$horizontally" = "1" ]; then
        convert -flop $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
      fi
      if [ "$vertically" = "1" ]; then
        convert -flip $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
      fi
        cam_link="$DIR_TEL/picture/cam_new.jpg"
    else
      echo "$(date) : JPEG picture has an error" >> $log
      cam_link="$DIR_TEL/picture/cam_error.jpg"
    fi
  
    if [ -n "${led_off}" ]; then
      sleep $led_off_delay
      curl -H "Content-Type: application/json" -X POST $led_off
      echo "$(date) : LED off" >> $log
    fi
  else
   echo "$(date) : Cam link has an error" >> $log
   cam_link="$DIR_TEL/picture/no_cam.jpg"
  fi
}
