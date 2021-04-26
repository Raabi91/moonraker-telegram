#!/bin/bash

device="$1"

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $config_dir/telegram_config.sh


list_json=$(curl -s -G "http://127.0.0.1:$port/machine/device_power/status?"  --data-urlencode "$device")
echo $list_json
device_state=$(echo "$list_json" | grep -oP '(?<=": ")[^"]*')
echo $device_state

msg="Your $device is $device_state"
curl -s -X POST "https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid" -F text="$msg"
msg=""

exit 0