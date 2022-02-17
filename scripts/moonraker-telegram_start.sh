#!/bin/bash
MYDIR_START=`dirname $0`
DIR_START="`cd $MYDIR_START/../; pwd`"

. $DIR_START/multi_config.sh
. $DIR_START/example_config.sh

    if [ -e $config_dir/telegram_config.sh ]
    then
        cp $config_dir/telegram_config.sh $config_dir/telegram_config.conf
        rm $config_dir/telegram_config.sh
        chmod 777 $config_dir/telegram_config.conf
    fi

. $config_dir/telegram_config.conf

    if ! grep -q "log=" $DIR_START/multi_config.sh
    then
        log_moonraker=$(grep log_path: $config_dir/moonraker.conf)
        echo $var2 > /tmp/log.txt
        sed -i "s#~#${HOME}#g" /tmp/log.txt
        log_path_fine=$(grep -m1 "" /tmp/log.txt)
        echo "log=\"$log_path_fine/$multi_instanz.log\"" >> $DIR_START/multi_config.sh
        rm -rf /tmp/log.txt
    fi


. $DIR_START/multi_config.sh

    if ! [ -e $log ]
    then
     touch $log
    fi

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