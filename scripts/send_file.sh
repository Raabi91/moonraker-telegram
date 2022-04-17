#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. "$DIR_TEL/multi_config.sh"
. "$DIR_TEL/example_config.sh"
. "$config_dir/telegram_config.conf"


tokenurl="https://api.telegram.org/bot$token"

file="$1"
number="$2"

filename=$(grep -oP '(?<='$number' = )[^}]*' $DIR_TEL/scripts/$file)
echo $filename

wget -O /tmp/$filename http://127.0.0.1:$port/server/files/timelapse/$filename

curl -s -X POST "https://api.telegram.org/bot$token/sendVideo?chat_id=$chatid" -F video=@"/tmp/$filename"

rm /tmp/$filename

exit 0