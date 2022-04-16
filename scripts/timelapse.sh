#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $DIR_TEL/example_config.sh
. $config_dir/telegram_config.conf

list_json=$(curl -H "X-Api-Key: $api_key" -s "http://127.0.0.1:$port/server/files/directory?path=timelapse")
echo $list_json
echo 1
echo 1
list_clean=$(echo "$list_json" | grep -oP '(?<="filename": ")[^}]*')
echo $list_clean
echo $list_clean > /tmp/list_clean.txt
sed -i 's/" /|/g' /tmp/list_clean.txt
sed -i 's/"//g' /tmp/list_clean.txt
sed -i 's/ /%20/g' /tmp/list_clean.txt
list_fin="$(cat /tmp/list_clean.txt)"
echo $list_fin
IFS='|'
read -a strarr <<< "$list_fin"

last_word=$(echo ${strarr[${#strarr[@]}-1]})

number=1
rm timelapse.conf
touch timelapse.txt

keyboard=""
place=1
files=1
send=120
list=1

for str in ${strarr[@]}; do
  if [[ $str == *".mp4"* ]]; then
    name="${str//%20/ }"
    name=${name#"timelapse_"}
    name=${name%".mp4"}
    list="$number = $name"
    echo "$number = $str" >> timelapse.txt
      if  [ "$number" == "1" ]; then
        msg="Timelapse List (chose the number to get the file)"$'\n'"$list"
      else
        msg="${list1}"$'\n'"${list}"
      fi

    if [ "$last_word" = "$str" ]; then
        if [ "$place" = "1" ]; then
            keyboard="$keyboard[{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=2
        elif [ "$place" = "2" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}"
            place=3
        elif [ "$place" = "3" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}"
            place=4
        elif [ "$place" = "4" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=1
        fi
        files=$(echo "$files+1" | bc -l)
    else
        if [ $send = $files ]; then
        if [ "$place" = "1" ]; then
            keyboard="$keyboard[{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=2
        elif [ "$place" = "2" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}"
            place=3
        elif [ "$place" = "3" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}"
            place=4
        elif [ "$place" = "4" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=1
        fi
            files=$(echo "$files+1" | bc -l)
            curl -s -X POST "https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid" -F text="$msg" -F reply_markup="{\"inline_keyboard\":[$keyboard]}"
            msg=""
            send=$(echo "$send+$send" | bc -l)
            list=$(echo "$list+1" | bc -l)
            place=1
            keyboard=""   
        else
        if [ "$place" = "1" ]; then
            keyboard="$keyboard[{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=2
        elif [ "$place" = "2" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}"
            place=3
        elif [ "$place" = "3" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}"
            place=4
        elif [ "$place" = "4" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=1
        fi
          
            files=$(echo "$files+1" | bc -l)
        fi
    fi

    number=$(echo "$number+1" | bc -l)
  fi
done

curl -s -X POST "https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid" -F text="$msg" -F reply_markup="{\"inline_keyboard\":[$keyboard]}"
msg=""

exit 0