# Deinstallation

1. Remove this

```
[update_manager client moonraker-telegram]
type: git_repo
path: /home/pi/moonraker-telegram
origin: https://github.com/Raabi91/moonraker-telegram.git
env: /home/pi/.moonraker-telegram-env/bin/python
requirements: scripts/moonraker-telegram-requirements.txt
install_script: scripts/install.sh
```

from your moonraker configuration

2. Del the telegram.config over mainsail oder fluidd
3. go into ssh and stop moonraker-telegram

```
sudo systemctl stop moonraker-telegram
```

4. del the moonraker-telegram folder

```
rm -rf moonraker-telegram
```

5. del the .moonraker-telegram-env folder

```
rm -rf .moonraker-telegram-env
```

6. remove the systemd service

```
sudo rm /etc/systemd/system/moonraker-telegram.service
sudo systemctl daemon-reload
```

now ist moonraker-telegram is completely removed

if you use multiple installations you have to change the moonraker-telegram folder name and the systemd service name
