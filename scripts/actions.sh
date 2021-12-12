#!/bin/bash

take_picture()
{

  if curl --output /dev/null --silent --fail -r 0-0  "$webcam"; then
    echo "Webcam link is working" >> $log

    if [ -n "${led_on}" ]; then
      echo "Led on" >> $log
      curl -H "Content-Type: application/json" -X POST $led_on
      sleep $led_on_delay
    fi

   rm $DIR_TEL/picture/cam_new.jpg
   curl -m 20 -o $DIR_TEL/picture/cam_new.jpg $webcam

    if identify -format '%f' $DIR_TEL/picture/cam_new.jpg; then
      echo "Jpeg file is okay" >> $log
  
     convert -quiet -rotate $rotate $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg

      if [ "$horizontally" = "1" ]; then
        convert -quiet -flop $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
      fi
      if [ "$vertically" = "1" ]; then
        convert -quiet -flip $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
      fi
        cam_link="$DIR_TEL/picture/cam_new.jpg"
    else
      echo "JPEG picture has an error" >> $log
      cam_link="$DIR_TEL/picture/cam_error.jpg"
    fi
  
   if [ "$gif_enable" = "0" ]; then
    if [ -n "${led_off}" ]; then
      sleep $led_off_delay
      curl -H "Content-Type: application/json" -X POST $led_off
      echo "LED off" >> $log
    fi
   fi
  else
   echo "Webcam link has an error" >> $log
   cam_link="$DIR_TEL/picture/no_cam.jpg"
  fi
}

create_varibales()
{
print=$(curl -H "X-Api-Key: $api_key" -s "http://127.0.0.1:$port/printer/objects/query?print_stats&display_status&gcode_move&extruder=target,temperature&heater_bed=target,temperature")
#### Filename ####
print_filename=$(echo "$print" | grep -oP '(?<="filename": ")[^"]*')
filename="${print_filename// /%20}"
file=$(curl -H "X-Api-Key: $api_key" -s "http://127.0.0.1:$port/server/files/metadata?filename=$filename")
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

layer_height=$(echo "$file" | grep -oP '(?<="layer_height": )[^,]*')
first_layer_height=$(echo "$file" | grep -oP '(?<="first_layer_height": )[^,]*')
object_height=$(echo "$file" | grep -oP '(?<="object_height": )[^,]*')
gcode_position=$(echo "$print" | grep -oP '(?<="gcode_position": )[^"]*')
gcode_position="${gcode_position// /}"
IFS=',' read -r -a array <<< "$gcode_position"
z_current=$(echo "${array[2]}")

if (( $(echo "$z_current > $first_layer_height" | bc -l) )); then
 layer1=$(echo "scale=0; $z_current-$first_layer_height" | bc -l)
 layer2=$(echo "scale=0; $layer1/$layer_height" | bc -l)
 current_layer=$(echo "scale=0; $layer2+1" | bc -l)
else
 current_layer=1
fi

layer1=$(echo "scale=0; $object_height-$first_layer_height" | bc -l)
layer2=$(echo "scale=0; $layer1/$layer_height" | bc -l)
layers=$(echo "scale=0; $layer2+1" | bc -l)


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
}