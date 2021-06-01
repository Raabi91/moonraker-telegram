#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $DIR_TEL/example_config.sh
. $config_dir/telegram_config.sh

file_id="$1"
file_name="$2"

getFile=$(curl -s "https://api.telegram.org/bot$token/getFile?file_id=$file_id")
#### Filename ####
file_path=$(echo "$getFile" | grep -oP '(?<="file_path":")[^"]*')

echo $file_path
## get File
curl -o /tmp/$file_name "https://api.telegram.org/file/bot$token/$file_path"
curl -k -H "X-Api-Key: dsdsda" -F "select=false" -F "print=false" -F "file=@/tmp/$file_name" "http://127.0.0.1:$port/server/files/upload"
rm /tmp/$file_name