# moonraker-telegram

A Script/Programm to send the printer State before, during and after a print via Telegram Messenger. But its only Working with moonraker


## Update_Mangager now Suppoertet

if you wan´t to use the updatet manager from moonraker for update moonraker-telegram, then you need to reinstall moonraker telegram

here is the how to:

 1. save your telegram_config.sh on your pc (copy & paste)
 2. Go into ssh an remove the moonraker-telegram folder
 ´´´
 rm -rf moonraker-telegram
 ´´´
 3. do a new [Installation](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/Installation.md)
 4. Add the the update manager config to your moonraker config you will find it in the [FAQ](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/FAQ.md)
 5. restore your telegram_config.sh
 6. restart moonraker-telegram
 ´´´
 sudo systemctl restart moonraker-telegram
 ´´´



## [changelog](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/changelog.md)


### if you have a problem to edit your config do an upgrade

## until now we supported:

- Print start
- Print Complete
- Print Paused
- Print Failed
- Send State timed
- First Commands avaible (/state, /pause, /resume, /cancel, /help)
- You can deactivate the messages by not entering any text at the config
- send own messages (with a picture) via klipper shell plugin an gcode macros (see [FAQ](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/FAQ.md))
- multiple bots for multiple moonraker setups (see [FAQ](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/FAQ.md))

## Info / Contact / Help

If you want to talk to other users of this plugin and maybe have some influence in the development of this plugin, you can join the [Moonraker-Telegram-Group](https://t.me/joinchat/HEI8MD3rG1qhl7tg)

## [Installation](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/Installation.md)

For installation lock at [Installation.md](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/Installation.md) in the docs folder

thanks to sugar0 for a link to an italian install quide: https://klipper-italia.xyz/extra/installazione-moonraker-telegram/

## [FAQ](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/FAQ.md)

Do you have more Question look at the [FAQ](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/FAQ.md)

---

**Klipper** by [KevinOConnor](https://github.com/KevinOConnor) :

https://github.com/KevinOConnor/klipper

---

**Moonraker** by [Arksine](https://github.com/Arksine) :

https://github.com/Arksine/moonraker

---

**Mainsail Webinterface** by [meteyou](https://github.com/meteyou) :

https://github.com/meteyou/mainsail

---

**Fluidd Webinterface** by [cadriel](https://github.com/cadriel) :

https://github.com/cadriel/fluidd

---
