#!/bin/bash

MYDIR=`dirname $0`
DIR="`cd $MYDIR/../; pwd`"

echo "\n\n========= moonraker-telegram - Installation Script ==========="

sudo apt-get install bc
sudo apt-get install python3
sudo apt-get install python3-pip
pip3 install requests
pip3 install telepot


echo "\n\n========= Creat telegram_config.sh ==========="

echo -e "\n\n========= pleas input your settings description on github ==========="
echo -e "\n\nyour moonraker config path (like /home/pi/klipper_config):"
read CONFIG

cp -i $DIR/example_config.sh $DIR/telegram_config.sh
sudo cp -s $DIR/telegram_config.sh $CONFIG/telegram_config.sh



echo "\n\n========= set permissions ==========="
sleep 1
chmod 755 $DIR/scripts/telegram.sh
chmod 755 $DIR/scripts/read_state.sh
sudo chmod 777 $DIR/telegram_config.sh

echo "\n\n========= installation autostart ==========="

crontab -u pi -l | grep -v "$DIR"  | crontab -u pi -
sleep 1
(crontab -u pi -l ; echo "@reboot sh $DIR/scripts/read_state.sh  &") | crontab -u pi -

echo "\n\n========= installation end ==========="
echo "\n\n========= open and edit your config with ==========="
echo "\n\n========= sudo nano $DIR/telegram_config.sh ==========="
echo "\n\n========= or use mainsail or fluidd and edit the telegram_config.sh ==========="


exit 1