#!/bin/sh

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $DIR_TEL/example_config.sh
. $config_dir/telegram_config.sh

take_picture()
{
  if [ -n "${led_on}" ]; then
    curl -H "Content-Type: application/json" -X POST $led_on
    sleep $led_on_delay
  fi  
  curl -o $DIR_TEL/picture/cam_new.jpg $webcam

  convert -rotate $rotate $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg

  if [ "$horizontally" = "1" ]; then
    convert -flop $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
  fi
  if [ "$vertically" = "1" ]; then
    convert -flip $DIR_TEL/picture/cam_new.jpg $DIR_TEL/picture/cam_new.jpg
  fi
  if [ -n "${led_off}" ]; then
    sleep $led_off_delay
    curl -H "Content-Type: application/json" -X POST $led_off
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

if [ "$custom_picture" = "1" ]; then
    msg="$state_msg"
    take_picture
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

exit 0