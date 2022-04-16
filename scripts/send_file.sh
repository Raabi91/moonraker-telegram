#!/bin/bash

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. "$DIR_TEL/multi_config.sh"
. "$DIR_TEL/example_config.sh"
. "$config_dir/telegram_config.conf"
. "$DIR_TEL/scripts/actions.sh"
echo "telegram.sh" >> "$log"

create_variables

. "$config_dir/telegram_config.conf"

tokenurl="https://api.telegram.org/bot$token"

file="$1"
number="$2"

filename=$(grep -oP '(?<=$number = )[^}]*' $DIR_TEL/scripts/$file)
echo $filename