#!/bin/sh

MYDIR_TEL=`dirname $0`
DIR_TEL="`cd $MYDIR_TEL/../; pwd`"

. $DIR_TEL/multi_config.sh
. $DIR_TEL/example_config.sh
. $config_dir/telegram_config.sh
log=/tmp/$multi_instanz.log
echo "$(date) : telegram_custom" >> $log

. $DIR_TEL/scripts/actions.sh
. $config_dir/telegram_config.sh

tokenurl="https://api.telegram.org/bot$token"
state_msg="$1"
custom_picture="$2"

create_varibales

if [ "$custom_picture" = "1" ]; then
    msg="$state_msg"
    take_picture
    curl -s -X POST \
      ${tokenurl}/sendPhoto \
      -F chat_id=${chatid} \
      -F photo="@$cam_link" \
      -F caption="${msg}"
else 
    msg="$state_msg"
    curl -s -X POST \
    ${tokenurl}/sendMessage \
    -d text="${msg}" \
    -d chat_id=${chatid}
fi
echo "$(date) : Send MSG = $msg" >> $log

exit 0