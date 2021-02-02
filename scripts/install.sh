#!/bin/bash

MYDIR=`dirname $0`
DIR="`cd $MYDIR/../; pwd`"

echo "\n\n========= moonraker-telegram - Installation Script ==========="

sudo apt-get install bc
sudo apt-get install python3
sudo apt-get install python3-pip
sudo apt-get install python3-setuptools
pip3 install requests
pip3 install telepot


echo "\n\n========= Check for telegram_config.sh ==========="
if [ -e $DIR/telegram_config.sh ]
then;
else
    cp $DIR/example_config.sh $DIR/telegram_config.sh
fi

if ! grep -q "config_dir=" $DIR/telegram_config.sh
    then
    echo -e "\n\n========= pleas input your settings description on github ==========="
    echo -e "\n\nyour moonraker config path (like /home/pi/klipper_config):"
    read CONFIG 
    echo "# moonraker config path" >> $DIR/scripts/telegram_config.sh
    echo "config_dir="$CONFIG"" >> $DIR/scripts/telegram_config.sh
elif ! grep -q "bot_disable=" $DIR/telegram_config.sh
    then 
    echo "# Make all commands Disable with 1" >> $DIR/scripts/telegram_config.sh
    echo "bot_disable="0"" >> $DIR/scripts/telegram_config.sh        
fi


. $DIR/telegram_config.sh

    sudo cp -s $DIR/telegram_config.sh $config_dir/telegram_config.sh
    echo $config_dir/telegram_config.sh


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
