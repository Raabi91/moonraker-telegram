# FAQ

## How to set up updatet manager from moonraker

add this

```
[update_manager client moonraker-telegram]
type: git_repo
path: /home/pi/moonraker-telegram
origin: https://github.com/Raabi91/moonraker-telegram.git
env: /home/pi/.moonraker-telegram-env/bin/python
requirements: scripts/moonraker-telegram-requirements.txt
install_script: scripts/install.sh
```

too your moonraker config

## Update_Mangager shows drity or false

if the update manager shows an error you have to do the following

here is the how to:

1.  save your telegram_config.sh on your pc (copy & paste)
2.  Go into ssh an remove the moonraker-telegram folder
    ´´´
    rm -rf moonraker-telegram
    ´´´
3.  do a new [Installation](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/Installation.md)
4.  restore your telegram_config.sh when is not correct
5.  restart moonraker-telegram
    ´´´
    sudo systemctl restart moonraker-telegram
    ´´´

## How Upgrade the script in SSH

if you use multiple bots. you must first go in the folder you created

```
cd Your_folder_name
```

then perform the update with the difference that the service name must be adapted to the instance. (sudo systemctl restart moonraker-telegramxxxx)

execute the code wenn you will ask to overwrite your telegram_config.sh say no

```
cd moonraker-telegram
git pull
./scripts/install.sh
```

then restart moonraker-telegram

```
sudo systemctl restart moonraker-telegram
```

if you have

```
# moonraker config path
config_dir=/home/pi/klipper_config
```

in telegram_config.sh you musst del it manuel at the moment. the text afer config_dir= can be any

## How Edit my config with mainsail

got to Mainsail -> Settings -> Maschine

and go into the config folder than you can edit the telegram_config.sh

After Edit the Config do a Reboot

## How Edit my config with fluidd

got to Mainsail -> Printer -> config tab

now you can edit the telegram_config.sh

After Edit the Config do a Reboot

## How to send own messages via klipper shell plugin

first of all you need to install the shell plugin for klipper.
does this best per kiauh. you find it at the Advanced section.

then you musst add the shell comand to your printer.cfg like this

```
[gcode_shell_command telegram]
command: sh /home/pi/moonraker-telegram/scripts/telegram.sh "this is a message from your printer" "0"
timeout: 2.
verbose: false
```

the message In the "" you can edit at your owne message. the second "" is for a picture with 0 it will send no picture.

here some examples for the command line:

```
Only Text:
sh /home/pi/moonraker-telegram/scripts/telegram.sh "this is a message from your printer" "0"

Text and picture:
sh /home/pi/moonraker-telegram/scripts/telegram.sh "this is a message from your printer" "1"

Only picture:
sh /home/pi/moonraker-telegram/scripts/telegram.sh "" "1"
```

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
only with the difference that you have to enter a suitable string when asking for multi installations so that you can later distinguish between the 2 Telegram installations.

this string ensures that your further instances get their own name, which is added after moonraker-telegram in systemd.

if you have specified "1" in the mullti instance, the service for it is "moonraker-telegram1". if you have specified "\_voron", it is "moonraker-telegram_voron".

these service names are needed for restarting

## How Too commands over button

Tell the botfather which commands are available. This enables Telegram to auto-complete commands to your bot. Send /setcommands to @botfather, select the bot and then send the lines in the box below (one message with multiple lines).

```
state - Sends the current status including a current photo.
pause - Pause current Print.  A confirmation is required
resume - resume current Print.
cancel - Aborts the currently running print. A confirmation is required
help - show list of commands.
print - Will open a file dialog showing the files stored in moonraker. You can select a file to print it.
```
