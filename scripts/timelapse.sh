#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $DIR_TEL/example_config.sh
. $config_dir/telegram_config.conf

list_json=$(curl -H "X-Api-Key: $api_key" -s "http://127.0.0.1:$port/server/files/directory?path=timelapse")
list_clean=$(echo "$list_json" | grep -oP '(?<="filename": ")[^}]*')
echo $list_clean > /tmp/list_clean.txt
sed -i 's/" /|/g' /tmp/list_clean.txt
sed -i 's/"//g' /tmp/list_clean.txt
sed -i 's/ /%20/g' /tmp/list_clean.txt
list_fin="$(cat /tmp/list_clean.txt)"
rm /tmp/list_clean.txt
IFS='|'
read -a strarr <<< "$list_fin"

last_word=$(echo ${strarr[${#strarr[@]}-1]})

number=1
rm timelapse.txt
touch timelapse.txt

keyboard=""
place=1
files=1
send=5
list=1

for str in ${strarr[@]}; do
  if [[ $str == *".mp4"* ]]; then
    name="${str//%20/ }"
    name=${name#"timelapse_"}
    name=${name%".mp4"}
    list_msg="$number = $name"
    echo "$number = $str" >> timelapse.txt
    
      if  [ "$number" == "1" ]; then
        list1="Timelapse List $list"$'\n'"------------"$'\n'"$list_msg"
      else
        list1="${list1}"$'\n'"------------"$'\n'"${list_msg}"
      fi
    msg="$list1"
    if [ "$last_word" = "$str" ]; then
        if [ "$place" = "1" ]; then
            keyboard="$keyboard[{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=2
        elif [ "$place" = "2" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=3
        elif [ "$place" = "3" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=4
        elif [ "$place" = "4" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=5
        elif [ "$place" = "5" ]; then
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
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=3
        elif [ "$place" = "3" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=4
        elif [ "$place" = "4" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=5
        elif [ "$place" = "5" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}]"
            place=1
        fi
            files=$(echo "$files+1" | bc -l)
            curl -s -X POST "https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid" -F text="$msg" -F reply_markup="{\"inline_keyboard\":[$keyboard]}"
            msg=""
            send=$(echo "$send+$send" | bc -l)
            list=$(echo "$list+1" | bc -l)
            list1="Timelapse List $list"
            place=1
            keyboard=""   
        else
        if [ "$place" = "1" ]; then
            keyboard="$keyboard[{\"text\":\"$number\",\"callback_data\":\"time:,$number\"},"
            place=2
        elif [ "$place" = "2" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"},"
            place=3
        elif [ "$place" = "3" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"},"
            place=4
        elif [ "$place" = "4" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"},"
            place=5
        elif [ "$place" = "5" ]; then
            keyboard="$keyboard{\"text\":\"$number\",\"callback_data\":\"time:,$number\"}],"
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