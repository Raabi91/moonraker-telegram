# moonraker-telegram

A Script/Programm to send the printer state before, during and after a print via Telegram Messenger. But its only working with moonraker

## Changelog

**If you have a problem to edit your config, do an upgrade first**

You can find the Changelog [here](docs/changelog.md)

## Currently Supported Actions

- Print Start
- Print Complete
- Print Paused
- Print Failed
- Send State timed, processed and at heights
- Commands available (``/state``, ``/pause``, ``/resume``, ``/cancel``, ``/help``, ``/print``, ``/power``, ``/gcode_macros``, ``/gif``, ``/host``)
- You can deactivate the messages by not entering any text in the config
- Send custom messages (with a picture) via klipper shell plugin and gcode macros (see [FAQ](docs/FAQ.md))
- Multiple bots for multiple moonraker setups (see [FAQ](docs/FAQ.md))
- .gcode uploads
- Automatic led on/off at picture for powermanager oder gcode macro

for the placeholders in the messages look at the [variables documentation](docs/Variables.md)

## Info / Contact / Help

If you want to talk to other users of this plugin and maybe have some influence in the development of this plugin, you can join the [Moonraker-Telegram-Group](https://t.me/joinchat/HEI8MD3rG1qhl7tg)

## Installation

For installation guide please look at [Installation](docs/Installation.md) guide

Thanks to sugar0 for a link to an italian install quide: https://klipper-italia.xyz/extra/installazione-moonraker-telegram/

## FAQ

Do you have more questions please look at the [FAQ](docs/FAQ.md)

## Uninstallation

If you want to remove moonraker-telegram please then look at the [Uninstallation](docs/Uninstallation.md) guide.

## References

- [Klipper](https://github.com/KevinOConnor/klipper) by [KevinOConnor](https://github.com/KevinOConnor)
- [Moonraker](https://github.com/Arksine/moonraker) by [Arksine](https://github.com/Arksine)
- [Mainsail](https://github.com/meteyou/mainsail) Webinterface by [meteyou](https://github.com/meteyou)
- [Fluidd](https://github.com/cadriel/fluidd) Webinterface by [cadriel](https://github.com/cadriel)
