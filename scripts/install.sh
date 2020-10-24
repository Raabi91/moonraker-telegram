#!/bin/bash

echo "\n\n========= moonraker-telegram - Installation Script ==========="

sudo apt-get install bc

echo "\n\n========= Creat telegram_config.sh ==========="

cp -i /home/pi/moonraker-telegram/example_config.sh /home/pi/moonraker-telegram/telegram_config.sh
cp -s /home/pi/moonraker-telegram/telegram_config.sh /home/pi/klipper_config/telegram_config.sh



echo "\n\n========= set permissions ==========="
sleep 1
chmod 755 /home/pi/moonraker-telegram/scripts/telegram.sh
chmod 755 /home/pi/moonraker-telegram/scripts/read_state.sh
chmod 755 /home/pi/moonraker-telegram/telegram_config.sh

echo "\n\n========= installation autostart ==========="

crontab -u pi -l | grep -v "/home/pi/moonraker-telegram/scripts/read_state.sh"  | crontab -u pi -
sleep 1
(crontab -u pi -l ; echo "@reboot sh /home/pi/moonraker-telegram/scripts/read_state.sh  &") | crontab -u pi -

echo "\n\n========= installation end ==========="
echo "\n\n========= open and edit your config with ==========="
echo "\n\n========= sudo nano /home/pi/moonraker-telegram/telegram_config.sh ==========="
echo "\n\n========= or use mainsail and edit the telegram_config.sh ==========="


exit 1