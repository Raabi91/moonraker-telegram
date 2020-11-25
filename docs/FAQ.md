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

## How to send own messages via klipper shell plugin

first of all you need to install the shell plugin for klipper. 
does this best per kiauh. you find it at the Advanced section.

the you musst add the shell comand to your printer.cfg like this

```
[gcode_shell_command telegram]
command: sh /home/pi/moonraker-telegram/scripts/telegram.sh "this is a message from your printer"
timeout: 2.
verbose: false
```

the message In the "" you can edit at your owne message

if you need more mesages the copy an paste your first message an edit the name like
```
[gcode_shell_command telegram1]
```
to call the comand use
```
RUN_SHELL_COMMAND CMD=telegram
```
now you can add the call in a gcode macro. here is a example
```
[gcode_macro telegram]
gcode:
    RUN_SHELL_COMMAND CMD=telegram 
```
