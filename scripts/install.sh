#!/bin/bash

MYDIR=`dirname $0`
DIR="`cd $MYDIR/../; pwd`"

echo "\n\n========= moonraker-telegram - Installation Script ==========="

sudo apt-get install bc
sudo apt-get install python3
sudo apt-get install python3-pip
sudo apt-get install python3-setuptools
pip3 install wheel
pip3 install websocket_client
pip3 install requests
pip3 install telepot



echo "\n\n========= Check for telegram_config.sh ==========="
if ! [ -e $DIR/telegram_config.sh ]
then
    cp $DIR/example_config.sh $DIR/telegram_config.sh
fi

if ! grep -q "config_dir=" $DIR/telegram_config.sh
    then
    echo -e "\n\n========= pleas input your settings description on github ==========="
    echo -e "\n\nyour moonraker config path (like /home/pi/klipper_config):"
    read CONFIG 
    echo '\n # moonraker config path' >> $DIR/telegram_config.sh
    echo "config_dir="$CONFIG"" >> $DIR/telegram_config.sh
fi
if ! grep -q "bot_disable=" $DIR/telegram_config.sh
    then 
    echo '# Make all commands Disable with 1' >> $DIR/telegram_config.sh
    echo 'bot_disable="0"' >> $DIR/telegram_config.sh        
fi


. $DIR/telegram_config.sh

    cp -l $DIR/telegram_config.sh $config_dir/telegram_config.sh


echo "\n\n========= set permissions ==========="
sleep 1
sudo chmod 755 $DIR/scripts/telegram.sh
sudo chmod 755 $DIR/scripts/read_state.sh
sudo chmod 755 $DIR/scripts/time_msg.sh
sudo chmod 755 $DIR/scripts/bot.py
sudo chmod 755 $DIR/scripts/moonraker-telegram_start.sh
sudo chmod 755 $DIR/scripts/websocket-connection-telegram.py
sudo chmod 777 $DIR/telegram_config.sh

echo "\n\n========= install autostart ==========="

crontab -u pi -l | grep -v "$DIR"  | crontab -u pi -
sleep 1
(crontab -u pi -l ; echo "@reboot sh $DIR/scripts/moonraker-telegram_start.sh &") | crontab -u pi -

echo "\n\n========= installation end ==========="
echo "\n\n========= open and edit your config with ==========="
echo "\n\n========= sudo nano $DIR/telegram_config.sh ==========="
echo "\n\n========= or use mainsail or fluidd and edit the telegram_config.sh ==========="


exit 1
