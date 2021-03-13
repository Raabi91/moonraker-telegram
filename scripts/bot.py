import time
import telepot
import os
import requests
import sys
from telepot.loop import MessageLoop
from telepot.namedtuple import InlineKeyboardMarkup, InlineKeyboardButton

token = sys.argv[1]
port = sys.argv[2]
DIR = sys.argv[3]
chatid_mt = sys.argv[4]

def on_chat_message(msg):
    chat_id = msg['chat']['id']
    command = msg['text']
    print ('Got chat: %s' % chat_id)
    print ('chat  id: %s' % chatid_mt)
    print ('Got command: %s' % command)
    
    
    if msg['from']['id'] != int(chatid_mt):
        print ('chat id are not same')
        bot.sendMessage(chat_id, 'you have no permission to communicate with me.')
    else:
        print ('chat id are same')
        if command == '/help':
            os.system(f'sh {DIR}/scripts/telegram.sh 6')
        elif command == '/state':
            os.system(f'sh {DIR}/scripts/telegram.sh 5')
        elif command == '/pause':
            content_type, chat_type, chat_id = telepot.glance(msg)
            keyboard = InlineKeyboardMarkup(inline_keyboard=[
                [InlineKeyboardButton(text='yes', callback_data='yes_pause')],
                [InlineKeyboardButton(text='no', callback_data='NO')],
                ])
            bot.sendMessage(chat_id, 'do you really want to pause', reply_markup=keyboard)
        elif command == '/resume':
            x = requests.post(f'http://127.0.0.1:{port}/printer/print/resume')
            print(x.text)
        elif command == '/cancel':
            content_type, chat_type, chat_id = telepot.glance(msg)
            keyboard = InlineKeyboardMarkup(inline_keyboard=[
                [InlineKeyboardButton(text='yes', callback_data='yes_cancel')],
                [InlineKeyboardButton(text='no', callback_data='NO')],
                ])
            bot.sendMessage(chat_id, 'do you really want to abort', reply_markup=keyboard)
            
def on_callback_query(msg):
    query_id, from_id, query_data = telepot.glance(msg, flavor='callback_query')
    print('Callback Query:', query_id, from_id, query_data)
    if query_data == 'yes_cancel':
        x = requests.post(f'http://127.0.0.1:{port}/printer/print/cancel')
        print(x.text)
        bot.sendMessage(from_id, 'Got it')
    elif query_data == 'yes_pause':
        x = requests.post(f'http://127.0.0.1:{port}/printer/print/pause')
        print(x.text)
        bot.sendMessage(from_id, 'Got it')

bot = telepot.Bot(f'{token}')

MessageLoop(bot, {'chat': on_chat_message,
                  'callback_query': on_callback_query}).run_as_thread()
print ('I am listening ...')

while 1:
    time.sleep(10)
import requests