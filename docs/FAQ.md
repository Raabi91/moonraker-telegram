# FAQ

## How to set up Moonraker's update_manager for moonraker-telegram.

Add this to your Moonraker config;

```
[update_manager client moonraker-telegram]
type: git_repo
path: /home/pi/moonraker-telegram
origin: https://github.com/Raabi91/moonraker-telegram.git
env: /home/pi/.moonraker-telegram-env/bin/python
requirements: scripts/moonraker-telegram-requirements.txt
install_script: scripts/install.sh
```

## Update_Manager shows invalid or false

If the update manager shows an error you must perform the following;

1.  Save your telegram_config.sh on your computer.
2.  Login to the terminal and remove the moonraker-telegram folder.
    ´´´
    rm -rf moonraker-telegram
    ´´´
3.  Perform a new [Installation](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/Installation.md).
4.  Restore your telegram_config.sh after reinstallation.
5.  Restart moonraker-telegram.
    ´´´
    sudo systemctl restart moonraker-telegram
    ´´´

## Use the bot in Groups

if you want to use your bot in a group you have to do the following for your bot

first set the privacy of the bot to disable

```
Got to @botfather chat and call comand

/setprivacy -> Select the correct bot -> Disable
```

then invite the bot to the group and give him admin rights


## How to upgrade moonraker-telegram via terminal

If you use multiple bots you must first enter into each specific folder you created for those bots;

```
cd Your_folder_name
```

Then perform the update with the difference that the service name must be adapted to the instance. (sudo systemctl restart moonraker-telegramxxxx)

Execute the code. When you are asked to overwrite your telegram_config.sh say no.

```
cd moonraker-telegram
git pull
./scripts/install.sh
```

Then restart moonraker-telegram

```
sudo systemctl restart moonraker-telegram
```

If you have

```
# moonraker config path
config_dir=/home/pi/klipper_config
```

in telegram_config.sh you must delete it manually for the moment. The text afer config_dir= can be anything.

## How to edit the config with Mainsail

Go to Mainsail -> Settings -> Machine

and go into the config folder, then you can edit the telegram_config.sh.

After editing the config reboot your machine.

## How to edit the config with fluidd

Go to Mainsail -> Printer -> Config tab

Now you are able to edit the telegram_config.sh.

After editing the config reboot your machine.

## New variables are not displayed in my config?

this is normal because moonraker-telegram accesses a sample config in the background. if you want to change a variable just copy the appropriate variable from [telegram_config.md](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/Telegram_config.md). Then copy it into your config and change the value.

## How to send your own custom messages via Klipper

first of all check if [respond] is present in your printer config if not add it. 

then set up a custom gcode macro like

```
[gcode_macro telegram_MSG]
gcode:
    RESPOND PREFIX=telegram: MSG="your message"
```

the prefix is used to specify whether you only want a message or also an image

PREFIX=telegram: is for messages only

PREFIX=telegram_picture: is for messages with picture

so you need only a picture see the examples

Examples:

```
Only Text:
[gcode_macro telegram_MSG]
gcode:
    RESPOND PREFIX=telegram: MSG="your message"

Text and picture:
[gcode_macro telegram_MSG+picture]
gcode:
    RESPOND PREFIX=telegram_picture: MSG="your message"

Only picture:
[gcode_macro telegram_picture]
gcode:
    RESPOND PREFIX=telegram_picture: MSG=""
```

If you need more messages just copy and paste the first macro and edit it

## How to run multiple bots

### To use this you must use a second bot in Telegram

Create a directory for a second bot like;

```
mkdir telegram1
```

Then go in to the folder;

```
cd telegram1
```

Now perform a normal [installation](https://github.com/Raabi91/moonraker-telegram/blob/main/README.md)
The only difference between these installs is that you have to enter a suitable string when asked for multi installation so that you can later distinguish between the 2 Telegram installations.

This string ensures that your further instances get their own name, which is added after moonraker-telegram in systemd.

If you have specified "1" in the mullti instance, the service for it is "moonraker-telegram1". if you have specified "\_voron", it is "moonraker-telegram_voron".

These service names are needed for restarting the services later on.

## How to use commands with buttons in Telegram

Tell the botfather which commands are available. This enables Telegram to auto-complete commands to your bot. Send /setcommands to @botfather, select the bot and then send the lines in the box below (one message with multiple lines).

```
state - Sends the current status including a current photo.
pause - Pause current Print.  A confirmation is required
resume - resume current Print.
cancel - Aborts the currently running print. A confirmation is required
help - show list of commands.
print - Will open a file dialog showing the files stored in moonraker. You can select a file to print it.
power - Will open a file dialog showing the Power devices of moonraker. You can choose a device to interact with it
gcode_macro - Will open a file dialog showing the custom Gcode_macros of the printer.cfg. You can choose a macro to execute it
gif - send a 5 second gif
```

## How to use Automatic led for cam

!!! written in advance the whole thing was designed at the moment only for the poweplugin of moonraker or gcode macros of klipper !!!

if the led varibals are missing you only have to copy them from the [Telegram_config.md](https://github.com/Raabi91/moonraker-telegram/blob/master/docs/Telegram_config.md) and paste them into your own.

the setup is actually quite simple and we subdivide depending on the control

### 1. Control of the leds via Power manager:

simply set the variables to the appropriate command and add the <device> with your device name.
if you have spaces in your device names, replace the spaces with %20

```
ON:
http://127.0.0.1:$port/machine/device_power/on?<device>

OFF:
http://127.0.0.1:$port/machine/device_power/off?<device>
```

Example

Moonraker.config

```
[power Tronxy X5SAPro]
type: gpio
pin: gpio4
.......
```

it must then look like this

```
ON:
http://127.0.0.1:$port/machine/device_power/on?Tronxy%20X5SAPro

OFF:
http://127.0.0.1:$port/machine/device_power/off?Tronxy%20X5SAPro
```

### 2. Control of the leds via gcode macro:

simply set the variables to the appropriate command and add the <macro> with your macro name.

```
http://127.0.0.1:$port/printer/gcode/script?script=<macro>
```

Example

printer.cfg

```
[gcode_macro led_on]
gcode:
....
```

it must then look like this

```
http://127.0.0.1:$port/printer/gcode/script?script=led_on
```

if you need some time after the power on command just set the delay variables there you can set a delay in seconds

## Gcode upload not work

Make sure your gcode is ending at .gcode an you have set [octoprint_compat] in the moonraker.config
