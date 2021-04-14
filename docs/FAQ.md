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

## How to send your own custom messages via Klipper shell plugin

First of all you need to install the shell plugin for Klipper.
This is best done via kiauh. You'll find this in the advanced section.

Once you've installed the shell plugin you must add the shell comand to your printer.cfg like this;

```
[gcode_shell_command telegram]
command: sh /home/pi/moonraker-telegram/scripts/telegram.sh "this is a message from your printer" "0"
timeout: 2.
verbose: false
```

The first quotes "" are for the message your printer will send. The second quotes "" dictates whether a picture will be sent - 0 for no picture, 1 to include picture.

Here are some examples for the command line;

```
Only Text:
sh /home/pi/moonraker-telegram/scripts/telegram.sh "this is a message from your printer" "0"

Text and picture:
sh /home/pi/moonraker-telegram/scripts/telegram.sh "this is a message from your printer" "1"

Only picture:
sh /home/pi/moonraker-telegram/scripts/telegram.sh "" "1"
```

If you need more messages just copy and paste the first message and edit the name like this;

```
[gcode_shell_command telegram1]
```

To call the command use;

```
RUN_SHELL_COMMAND CMD=telegram
```

Now you can add the call in a gcode macro. An example is;

```
[gcode_macro telegram]
gcode:
    RUN_SHELL_COMMAND CMD=telegram
```

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
```
