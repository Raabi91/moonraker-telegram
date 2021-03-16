# Installation

## Create a Telegram bot

1. Search for the @BotFather username in your Telegram application
2. Click Start to begin a conversation with @BotFather
3. Send /newbot to @BotFather. @BotFather will respond:
4. Send your bot’s name to @BotFather. Your bot’s name can be anything.
```
Note that this is not your bot’s Telegram @username. You will create the username in step 5.
```
5. Send your bot’s username to @BotFather. BotFather will respond:
6. Begin a conversation with your bot. Click on the t.me/<bot-username> link in @BotFather’s response and click Start at the bottom of your Telegram application. Your newly-created bot will appear in the chat list on the left side of the application.


## Get a Telegram API access token

Telegram’s @BotFather bot sent you an API access token when you created your bot. See the @BotFather response in step 5 of the previous section for where to find your token. If you can’t find the API access token, create a new token with the following steps below.

1. Send /token to @BotFather
2. Select the relevant bot at the bottom of your Telegram application. @BotFather responds with a new API access token:
```
You can use this token to access HTTP API:
<API-access-token>

For a description of the Bot API, see this page: https://core.telegram.org/bots/api
```

## Get your Telegram chat ID

1. Paste the following link in your browser. Replace <API-access-token> with the API access token that you identified or created in the previous section:
```
https://api.telegram.org/bot<API-access-token>/getUpdates?offset=0
```
2. Send a message to your bot in the Telegram application. The message text can be anything. Your chat history must include at least one message to get your chat ID.
3. Refresh your browser.

4. Identify the numerical chat ID by finding the id inside the chat JSON object. In the example below, the chat ID is 123456789.
```
{  
   "ok":true,
   "result":[  
      {  
         "update_id":XXXXXXXXX,
         "message":{  
            "message_id":2,
            "from":{  
               "id":123456789,
               "first_name":"Mushroom",
               "last_name":"Kap"
            },
            "chat":{  
               "id":123456789,
               "first_name":"Mushroom",
               "last_name":"Kap",
               "type":"private"
            },
            "date":1487183963,
            "text":"hi"
         }
      }
   ]
}
```

## Install The script on a pi

First of all check you have added [display_status] to your klipper config. when you have not do this

Download an install the plugin

if u use it the first time use this
```
cd
git clone https://github.com/Raabi91/moonraker-telegram
cd moonraker-telegram
```
then install the script with

```
./scripts/install.sh
```
during installation you will be asked for the config path of moonraker. enter the full path here. if you have only one instance of moonraker it should 
```
/home/pi/klipper_config
```
be

you will also be asked for multiple installations. 
If you have only one installation, you just have to confirm with enter. 
if you want to have multiple installations, have a look at the [FAQ](https://github.com/Raabi91/moonraker-telegram/blob/main/docs/FAQ.md).

then edit your config use mainsail or fluidd web interface

edit the variables between the ""

wenn you are finished restart monraker-telegram with

```
sudo systemctl restart moonraker-telegram
```

then add this

```
[update_manager client moonraker-telegram]
type: git_repo
path: /home/pi/moonraker-telegram
origin: https://github.com/Raabi91/moonraker-telegram.git
env: /usr/lib/python3/
requirements: scripts/moonraker-telegram-requirements.txt
install_script: scripts/install.sh
```

too your moonraker config for moonraker Update Manager