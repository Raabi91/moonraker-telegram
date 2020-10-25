# FAQ

## How Upgrade the script

execute the code wenn you will ask to overwrite your telegram_config.sh say no

```
cd ~/moonraker-telegram
git reset --hard HEAD
git pull
sh ./scripts/install.sh
sudo reboot
```

## How Edit my config after first instalation

you have 3 ways

1.
got to Mainsail -> Settings -> Maschine
and go into the config folder than you can edit the telegram_config.sh

2.
Open the config  in SSH an edit the settings

```
sudo nano /home/pi/powermanager/config.sh
```
3.
use Ftp and search the file to edit and reupload it. the path is /home/pi/powermanager/

After Edit the Config  do a Reboot