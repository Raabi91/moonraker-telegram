# FAQ

## How Upgrade the script

if you use multiple bots. you must first go in the folder you created

```
cd Your_folder_name
```

execute the code wenn you will ask to overwrite your telegram_config.sh say no

```
cd moonraker-telegram
git reset --hard HEAD
git pull --no-edit
sh ./scripts/install.sh
sudo reboot
```

## How Edit my config with mainsail

got to Mainsail -> Settings -> Maschine

and go into the config folder than you can edit the telegram_config.sh

After Edit the Config  do a Reboot

## How Edit my config with fluidd

got to Mainsail -> Printer -> config tab

now you can edit the telegram_config.sh

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

## How Too run multiple bots

### Too use this you musst use a second bot in telegram

Create a Dir for a second bot like

```
mkdir telegram1
```

then go in to the folder

```
cd telegram1
```
and now do a normal [installation](https://github.com/Raabi91/moonraker-telegram/blob/main/README.md)
