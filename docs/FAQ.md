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

## How Edit my config with mainsail

got to Mainsail -> Settings -> Maschine

and go into the config folder than you can edit the telegram_config.sh

After Edit the Config  do a Reboot

## How Edit my config with fluidd

got to Mainsail -> Printer -> config tab

now you can edit the telegram_config.sh

After Edit the Config  do a Reboot

## How Too run mormultiple bots

### Too use this you musst use a second bot in telegram

Create a Dir for a second bot like (the name )

```
mkdir telegram1
```

then go in to the folder

```
cd telegram1
```
and now do a normal [installation](https://github.com/Raabi91/moonraker-telegram/blob/main/README.md)
