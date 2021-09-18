#!/bin/bash
MYDIR_START=`dirname $0`
DIR_START="`cd $MYDIR_START/../; pwd`"

. $DIR_START/multi_config.sh
. $DIR_START/example_config.sh
. $config_dir/telegram_config.sh

log=/tmp/$multi_instanz.log
echo "$(date)" >> $log
echo "Start $multi_instanz" >> $log

if [ "$bot_disable" = "0" ]; then
${HOME}/.moonraker-telegram-env/bin/python $DIR_START/scripts/bot.py "$token" "$port" "$DIR_START" "$chatid" "$api_key" "$log" &
fi

echo "time_msg=0" > $DIR_START/scripts/time_config.txt
echo "time_pause=0" >> $DIR_START/scripts/time_config.txt

echo "print_state=0" > $DIR_START/scripts/state_config.txt
echo "pause=0" >> $DIR_START/scripts/state_config.txt

${HOME}/.moonraker-telegram-env/bin/python $DIR_START/scripts/websocket-connection-telegram.py "$port" "$DIR_START" "$config_dir" "$api_key" "$log" &