# FAQ

## How to set up Moonraker's update_manager for moonraker-telegram

Add this to your Moonraker config;

```ini
[update_manager client moonraker-telegram]
type: git_repo
path: /home/pi/moonraker-telegram
origin: https://github.com/Raabi91/moonraker-telegram.git
env: /home/pi/.moonraker-telegram-env/bin/python
requirements: scripts/moonraker-telegram-requirements.txt
install_script: scripts/install.sh
```

## How to use the /set comand

the ``/set`` command cannot be called from the / submenu because it needs variables which are structured as follows: ``/set:xxx:yy``

- Replace ``xxx`` by your extruder or heat bed name
- Replace ``yy`` by the temperature you want to change to

Examples:

```
/set:extruder:230
/set:heater_bed:60
```

## How to use Multicams

To use Multicams you need to extend 4 of your variables to generate a list and this varibales must be bracketed:

The variables you need are:

- webcam
- rotate
- horizontally
- vertically

Example for 3 cams

```
webcam=("http://127.0.0.1:8080/?action=snapshot" "http://127.0.0.1:8083/?action=snapshot" "http://127.0.0.1:8082/?action=snapshot")
rotate=("0" "180" "90")
horizontally=("0" "0" "1")
vertically=("0" "1" "0")
```

The relations among each other are linear to each other.

That means related to the example the first value in rotate = 0 refers to the first webcam (``http://127.0.0.1:8080/?action=snapshot``). 
The second value = 180 refers to the second webcam (``http://127.0.0.1:8081/?action=snapshot``).


## Update_Manager shows invalid or false

If the update manager shows an error you must perform the following;

1.  Save your telegram_config.sh on your computer.
2.  Login to the terminal and remove the moonraker-telegram folder.
    ```bash
    rm -rf moonraker-telegram
    ```
3.  Perform a new [Installation](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/Installation.md).
4.  Restore your telegram_config.sh after reinstallation.
5.  Restart moonraker-telegram.
    ```bash
    sudo systemctl restart moonraker-telegram
    ```

## Use the bot with force_logins: true

If you want to use your bot with ``force_logins: true`` then you just have to enter the [API KEY](https://github.com/Raabi91/moonraker-telegram/blob/master/docs/Telegram_config.md#Your-moonraker-API-Key-when-u-use-force-login-true) in your telegram_config.sh


## How to upgrade moonraker-telegram via terminal

If you use multiple bots you must first enter into each specific folder you created for those bots;

```bash
cd Your_folder_name
```

Then perform the update with the difference that the service name must be adapted to the instance. (``sudo systemctl restart moonraker-telegramxxxx``)

Execute the code. When you are asked to overwrite your ``telegram_config.sh`` reply no.

```bash
cd moonraker-telegram
git pull
./scripts/install.sh
```

Then restart moonraker-telegram

```bash
sudo systemctl restart moonraker-telegram
```

If you have

```ini
# moonraker config path
config_dir=/home/pi/klipper_config
```

in ``telegram_config.sh`` you must delete it manually for the moment. The text afer ``config_dir=`` can be anything.

## How to edit the config with Mainsail

Go to *Mainsail* -> *Settings* -> *Machine*

and go into the config folder, then you can edit the ``telegram_config.sh``.

After editing the config, restart moonraker-telegram with:

```
sudo systemctl restart moonraker-telegram
```

or simply reboot your machine.

## How to edit the config with fluidd

Go to *Mainsail* -> *Printer* -> *Config* tab

Now you are able to edit the ``telegram_config.sh``.

After editing the config, restart moonraker-telegram with:

```
sudo systemctl restart moonraker-telegram
```

or simply reboot your machine.

## New variables are not displayed in my config?

This is expected because moonraker-telegram accesses a sample config in the background. If you want to change a variable just copy the appropriate variable from [telegram_config](docs/Telegram_config.md) into your config and change the value.

## How to send your own custom messages via Klipper

First of all check if ``[respond]`` is present in your printer config if not add it. 
Then set up a custom gcode macro like the following: 

```ini
[gcode_macro telegram_MSG]
gcode:
    RESPOND PREFIX=telegram: MSG="your message"
```

The prefix is used to specify whether you only want a message or also an image

``PREFIX=telegram:`` is for messages only

``PREFIX=telegram_picture:`` is for pictures with an optional message

Examples:

```ini
# Send only a text via telegram
[gcode_macro telegram_MSG]
gcode:
    RESPOND PREFIX=telegram: MSG="your message"

# Send a picture with a text via telegram
[gcode_macro telegram_MSG+picture]
gcode:
    RESPOND PREFIX=telegram_picture: MSG="your message"

# Send only a picture via telegram
[gcode_macro telegram_picture]
gcode:
    RESPOND PREFIX=telegram_picture: MSG=""
```

If you need more messages just copy and paste the first macro and edit it

## How to run multiple bots

### To use this you must use a second bot in Telegram

Create a directory for a second bot like;

```bash
mkdir telegram1
```

Then go in to the folder:

```bash
cd telegram1
```

Now perform a normal [installation](https://github.com/Raabi91/moonraker-telegram/blob/main/README.md)
The only difference between these installs is that you have to enter a suitable string when asked for multi installation so that you can later distinguish between the 2 Telegram installations.

This string ensures that your further instances get their own name, which is added after moonraker-telegram in systemd.

If you have specified "1" in the mullti instance, the service for it is "moonraker-telegram1". if you have specified "\_voron", it is "moonraker-telegram_voron".

These service names are needed for restarting the services later on.

## How to use commands with buttons in Telegram

Tell the botfather which commands are available. This enables Telegram to auto-complete commands to your bot. Send ``/setcommands`` to ``@botfather``, select the bot and then send the lines in the box below (one message with multiple lines).

```
state - Current status including a photo
pause - Pause current print. A confirmation will be requested
resume - Resume current print.
cancel - Abort the current print. A confirmation will be requested
help - Show list of commands.
print - Select a file from moonraker for printing
power - Interact with power devices of moonraker
gcode_macro - Run custom GCode Macros of moonraker
gif - Send a 5 second gif
host - Restart Firmware or Klipper and reboot and shutdown of the Host
```

## How to use automatic led for cam

!!! **Attention: This is designed only for the powerplugin of moonraker or gcode macros of klipper** !!!

If the led variables are missing you only have to copy them from the [Telegram_config.md](https://github.com/Raabi91/moonraker-telegram/blob/master/docs/Telegram_config.md) and paste them into your own.

The setup is actually quite simple and we subdivide depending on the control

### 1. Control of the leds via Power manager:

Simply set the variables in the configuration to the appropriate command and replace the ``<device>`` with your device name. 
If you have spaces in your device names, replace the spaces with %20

```
led_on="http://127.0.0.1:$port/machine/device_power/on?<device>"
led_off"http://127.0.0.1:$port/machine/device_power/off?<device>"
```

Example if you have in your ``moonraker.config`` the following power configuration:

```ini
[power Tronxy X5SAPro]
type: gpio
pin: gpio4
#.......
```

Then the configuration for this device must be as follows

```
led_on="http://127.0.0.1:$port/machine/device_power/on?Tronxy%20X5SAPro"
led_off"http://127.0.0.1:$port/machine/device_power/off?Tronxy%20X5SAPro"
```

### 2. Control of the leds via gcode macro:

Simply set the variables in the configuration to the appropriate command and add the ``<macro>`` with your macro name.

```
led_on="http://127.0.0.1:$port/printer/gcode/script?script=<macro>"
led_off="http://127.0.0.1:$port/printer/gcode/script?script=<macro>"
```

Example

printer.cfg

```ini
[gcode_macro led_on]
gcode:
#....
```

Then the configuration for this gcode must be as follows

```
led_on="http://127.0.0.1:$port/printer/gcode/script?script=led_on"
```

If you need some time after the power on/off commands just set the delay variables the the desired amount of seconds.

## Gcode upload not work

Make sure your gcode is ending at .gcode and you that have set [octoprint_compat] in the moonraker.config
