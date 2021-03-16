#!/bin/bash
MYDIR_START=`dirname $0`
DIR_START="`cd $MYDIR_START/../; pwd`"

. $DIR_START/multi_config.sh


 ####### updates for the config ############

if ! grep -q "bot_disable=" $config_dir/telegram_config.sh
    then 
    echo -e "\n# Make all commands Disable with 1" >> $config_dir/telegram_config.sh
    echo 'bot_disable="0"' >> $config_dir/telegram_config.sh
fi
if ! grep -q "delay_start_msg=" $config_dir/telegram_config.sh
    then 
    echo -e "\n# delay for the Print start Message" >> $config_dir/telegram_config.sh
    echo 'delay_start_msg="0"' >> $config_dir/telegram_config.sh
fi
if ! grep -q "delay_end_msg=" $config_dir/telegram_config.sh
    then 
    echo -e "\n# delay for the Print end Message" >> $config_dir/telegram_config.sh
    echo 'delay_end_msg="0"' >> $config_dir/telegram_config.sh
fi
if ! grep -q "delay_pause_msg=" $config_dir/telegram_config.sh
    then 
    echo -e "\n# Delay for the Pause Message" >> $config_dir/telegram_config.sh
    echo 'delay_pause_msg="0"' >> $config_dir/telegram_config.sh
fi

echo 'testupdate"' >> $config_dir/telegram_config.sh

sudo chmod 777 $config_dir/telegram_config.sh

################################################


. $config_dir/telegram_config.sh

if [ "$bot_disable" = "0" ]; then
python3 $DIR_START/scripts/bot.py "$token" "$port" "$DIR_START" "$chatid" &
fi

echo "time_msg=0" > $DIR_START/scripts/time_config.txt
echo "time_pause=0" >> $DIR_START/scripts/time_config.txt

echo "print_state=0" > $DIR_START/scripts/state_config.txt
echo "pause=0" >> $DIR_START/scripts/state_config.txt

python3 $DIR_START/scripts/websocket-connection-telegram.py "$port" "$DIR_START" &
