import time
import telepot
import os
import requests
import sys
from telepot.loop import MessageLoop

token = sys.argv[1]
port = sys.argv[2]
DIR = sys.argv[3]

"""
After **inserting token** in the source code, run it:
```
$ python2.7 diceyclock.py
```
[Here is a tutorial](http://www.instructables.com/id/Set-up-Telegram-Bot-on-Raspberry-Pi/)
teaching you how to setup a bot on Raspberry Pi. This simple bot does nothing
but accepts two commands:
- `/roll` - reply with a random integer between 1 and 6, like rolling a dice.
- `/time` - reply with the current time, like a clock.
"""

def handle(msg):
    chat_id = msg['chat']['id']
    command = msg['text']

    print ('Got command: %s' % command)

    if command == '/help':
        os.system(f'sh {DIR}/scripts/telegram.sh 6')
    elif command == '/state':
        os.system(f'sh {DIR}/scripts/telegram.sh 5')
    elif command == '/pause':
        x = requests.post(f'http://127.0.0.1:{port}/printer/print/pause')
        print(x.text)
    elif command == '/resume':
        x = requests.post(f'http://127.0.0.1:{port}/printer/print/resume')
        print(x.text)
    elif command == '/cancel':
        x = requests.post(f'http://127.0.0.1:{port}/printer/print/cancel')
        print(x.text)

bot = telepot.Bot(f'{token}')

MessageLoop(bot, handle).run_as_thread()
print ('I am listening ...')

while 1:
    time.sleep(10)
import requests