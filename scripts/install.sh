#!/bin/bash

MYDIR=`dirname $0`
DIR="`cd $MYDIR/../; pwd`"

echo "========= moonraker-telegram - Installation Script ==========="

sudo apt-get install bc
sudo apt-get install python3
sudo apt-get install python3-pip
sudo apt-get install python3-setuptools
pip3 install wheel
pip3 install websocket_client
pip3 install requests
pip3 install telepot

echo -e "\n========= Check for config ==========="

if ! grep -q "config_dir=" $DIR/multi_config.sh
    then
    echo -e "========= pleas input your settings description on github ==========="
    echo -e "your moonraker config path (like /home/pi/klipper_config):"
    read CONFIG 
    echo -e "\n# moonraker config path" >> $DIR/multi_config.sh
    echo -e "config_dir="$CONFIG"" >> $DIR/multi_config.sh
fi
if ! grep -q "multi_instanz=" $DIR/multi_config.sh
    then 
    echo "if you want to use multiple instances on one pi, enter an identifier here. this is needed to create the sytemd service"
    echo "If you only use it once per hardware, simply press enter."
    read INSTANZ 
    echo "# if you want to use multiple instances on one pi, enter an identifier here. this is needed to create the sytemd service." > $DIR/multi_config.sh
    echo "multi_instanz="moonraker-telegram$INSTANZ"" >> $DIR/multi_config.sh      
fi

. $DIR/multi_config.sh

if ! [ -e $config_dir/telegram_config.sh ]
then
    sudo cp $DIR/example_config.sh $config_dir/telegram_config.sh
    sudo chmod 777 $config_dir/telegram_config.sh
fi

if [ -L $config_dir/telegram_config.sh ]
then
    sudo rm $config_dir/telegram_config.sh
    sudo cp $DIR/telegram_config.sh $config_dir/telegram_config.sh
    sudo rm $DIR/telegram_config.sh
    sudo chmod 777 $config_dir/telegram_config.sh
fi
if ! grep -q "bot_disable=" $config_dir/telegram_config.sh
    then 
    echo -e "\n# Make all commands Disable with 1" >> $config_dir/telegram_config.sh
    echo 'bot_disable="0"' >> $config_dir/telegram_config.sh
fi
if ! grep -q "delay_start_msg=" $config_dir/telegram_config.sh
    then 
    echo -e "\n# delay fot the Print start Message" >> $config_dir/telegram_config.sh
    echo 'delay_start_msg="0"' >> $config_dir/telegram_config.sh
fi
if ! grep -q "delay_end_msg=" $config_dir/telegram_config.sh
    then 
    echo -e "\n# delay fot the Print end Message" >> $config_dir/telegram_config.sh
    echo 'delay_end_msg="0"' >> $config_dir/telegram_config.sh
fi
if ! grep -q "delay_pause_msg=" $config_dir/telegram_config.sh
    then 
    echo -e "\n# Delay fot the Pause Message" >> $config_dir/telegram_config.sh
    echo 'delay_pause_msg="0"' >> $config_dir/telegram_config.sh
fi

. $config_dir/telegram_config.sh
    
echo -e "\n========= set permissions ==========="
sleep 1
sudo chmod 755 $DIR/scripts/bot.py
sudo chmod 755 $DIR/scripts/moonraker-telegram_start.sh
sudo chmod 755 $DIR/scripts/moonraker-telegram_stop.sh
sudo chmod 755 $DIR/scripts/read_state.sh
sudo chmod 755 $DIR/scripts/telegram.sh
sudo chmod 755 $DIR/scripts/time_msg.sh
sudo chmod 755 $DIR/scripts/websocket-connection-telegram.py
sudo chmod 777 $config_dir/telegram_config.sh

echo -e "\n========= install systemd ==========="

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
MTPATH=$(sed 's/\/scripts//g' <<< $SCRIPTPATH)

SERVICE=$(<$SCRIPTPATH/moonraker-telegram.service)
MTPATH_ESC=$(sed "s/\//\\\\\//g" <<< $MTPATH)
SERVICE=$(sed "s/MT_DESC/$multi_instanz/g" <<< $SERVICE)
SERVICE=$(sed "s/MT_USER/$USER/g" <<< $SERVICE)
SERVICE=$(sed "s/MT_DIR/$MTPATH_ESC/g" <<< $SERVICE)

echo "$SERVICE" | sudo tee /etc/systemd/system/$multi_instanz.service > /dev/null
sudo systemctl daemon-reload
sudo systemctl enable $multi_instanz

if crontab -l | grep -i /home/pi; then
    crontab -u pi -l | grep -v "$DIR"  | crontab -u pi -
    sleep 1
    (crontab -u pi -l ; echo "") | crontab -u pi -
fi

echo -e "\n========= start systemd for $multi_instanz ==========="

sudo systemctl start $multi_instanz
sudo systemctl restart $multi_instanz

echo -e "\n========= installation end ==========="
echo "========= open and edit your config with ==========="
echo "========= mainsail or fluidd and edit the telegram_config.sh ==========="


exit 1
