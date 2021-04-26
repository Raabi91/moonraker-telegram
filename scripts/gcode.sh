#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $config_dir/telegram_config.sh

list_json=$(curl -s "http://127.0.0.1:$port/printer/objects/list")
echo $list_json
list_clean=$(echo "$list_json" | grep -oP '(?<="gcode_macro )[^",]*')
echo $list_clean
echo $list_clean > /tmp/list_clean.txt
sed -i 's/" /|/g' /tmp/list_clean.txt
sed -i 's/"//g' /tmp/list_clean.txt

list_fin="$(cat /tmp/list_clean.txt)"

rm /tmp/list_clean.txt

IFS=' '

read -a strarr <<< "$list_fin"

last_word=$(echo ${strarr[${#strarr[@]}-1]})

keyboard=""
place=1
files=1
send=60
list=1

for f in ${strarr[@]}; do
    word_length=$(echo ${#f})
    if [ "$last_word" = "$f" ]; then
        if [ "$word_length" -gt "60" ]; then
            f="´gcode_macro_too_long"
        fi
        if [ "$place" = "1" ]; then
            keyboard="$keyboard[{\"text\":\"$f\",\"callback_data\":\"g:,$f\"}]"
            place=2
        elif [ "$place" = "2" ]; then
            keyboard="$keyboard{\"text\":\"$f\",\"callback_data\":\"g:,$f\"}]"
            place=1
        fi
        files=$(echo "$files+1" | bc -l)
    else
        if [ "$word_length" -gt "60" ]; then
            f="gcode_macro_too_long"
        fi
        if [ $send = $files ]; then
            if [ "$place" = "1" ]; then
                keyboard="$keyboard[{\"text\":\"$f\",\"callback_data\":\"g:,$f\"}]"
                place=2
            elif [ "$place" = "2" ]; then
                keyboard="$keyboard{\"text\":\"$f\",\"callback_data\":\"g:,$f\"}]"
                place=1
            fi
            files=$(echo "$files+1" | bc -l)
            msg="Your list $list"
            curl -s -X POST "https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid" -F text="$msg" -F reply_markup="{\"inline_keyboard\":[$keyboard]}"
            msg=""
            send=$(echo "$send+$send" | bc -l)
            list=$(echo "$list+1" | bc -l)
            place=1
            keyboard=""   
        else
            if [ "$place" = "1" ]; then
                keyboard="$keyboard[{\"text\":\"$f\",\"callback_data\":\"g:,$f\"},"
                place=2
            elif [ "$place" = "2" ]; then
                keyboard="$keyboard{\"text\":\"$f\",\"callback_data\":\"g:,$f\"}],"
                place=1
            fi
          
            files=$(echo "$files+1" | bc -l)
        fi
    fi
done

msg="Your list $list"
curl -s -X POST "https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid" -F text="$msg" -F reply_markup="{\"inline_keyboard\":[$keyboard]}"
msg=""

exit 0