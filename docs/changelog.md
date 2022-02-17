# 17.02.2022
 - move log file to path from moonraker.conf
 - rename telegram_conf.sh to telegram_conf.conf
 - add firmware restart and restart to /hostcomand
 - add /set:xxx:xx comand

# 12.08.2021

- add support for force login
- add comand for reboot and shutdown for the host system

# 12.06.2021

- message added at z height
- message added at Process in %

# 03.06.2021

- add gif="0" to config for additional Gif at printig state
- add first stepps for .log
- custom comands has been changed so that the klipper shell plugin is no longer needed
- camera and jpeg monitoring added when error present comes an image with error message
- actions improved

# 13.05.2021

- add /gif for 5 second gif
- update /help
- add gcode upload
- add automatic led for picture

# 09.05.2021

- add funktions for groupchat

# 29.04.2021

- add uninstallation.md
- new variables are no longer automatically added to telegram_config after an update
- add Telegram_config.md
- add standby message, complete message, paused message and error message as variable

# 26.04.2021

- add command /power
- add command /gcode_macro

# 01.04.2021

- switch python to to virtualenv

# 26.03.2021

- add /print command
- add placeholders for extruder temperature
- add placeholders for bed temperature

# 17.03.2021

- Spelling error corrected

# 16.03.2021 (v1.0.1)

- support for offical update manager

# 13.03.2021

- Confirmations for cancel and pause commands
- Delays for start, end and pause messages
- bugfixing in install.sh

# 08.03.2021

- fixing bugs
- rework the telegram\*config location

# 06.03.2021

- add function to send pictures over the custom command
- move installation from readme to docs

# 22.02.2021

- switch from crontab to systemd service (now you can restart moontaker\*telegram without a reboot)

# 17.02.2021

- switch from http request to websocket connection at read state

# 03.02.2021

- New install script
- Add option to disable all commands in config (you will see this after you have execute the new install script)
