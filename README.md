# moonraker-telegram
 A plugin to send the printer State  before, during and after a print via Telegram Messenger 

until now we supported:
- Print start
- Print Complete
- Print Paused
- Print Failed
- Send State timed

## Install The script on a pi

Download an install the plugin

if u use it the first time use this
```
cd
git clone https://github.com/Raabi91/moonraker-telegram
cd moonraker-telegram
sh ./scripts/install.sh
```
the edit your config with
```
sudo nano /home/pi/moonraker-telegram/telegram_config.sh
```
or use mainsail web interface

edit the variables between the ""

wenn you are finished reboot your pi to start the script automaticly

## FAQ

Do you have more Question look at the FAQ