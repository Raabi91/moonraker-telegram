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
api_key = sys.argv[5]
log = sys.argv[6]


def on_chat_message(msg):
    content_type, chat_type, chat_id = telepot.glance(msg, 'chat')
    print(content_type)
    print(chat_id)
    if str(chat_id) != chatid_mt:
        print('chat id are not same')
        bot.sendMessage(
            chat_id, 'you have no permission to communicate with me.')
    else:
        if content_type == 'document':
            file_id = msg['document']['file_id']
            file_name = msg['document']['file_name']
            if file_name.endswith('.gcode'):
                print(file_id)
                print(file_name)
                os.system(f'{DIR}/scripts/upload.sh "{file_id}" "{file_name}"')
        else:
            chat_id = msg['chat']['id']
            command = msg['text']
            if "@" in command:
                command, x = command.split("@")
            print('Got chat: %s' % chat_id)
            print('chat  id: %s' % chatid_mt)
            print('Got command: %s' % command)
            if str(chat_id) != chatid_mt:
                print('chat id are not same')
                bot.sendMessage(
                    chat_id, 'you have no permission to communicate with me.')
            else:
                print('chat id are same')
                if command == '/help':
                    os.system(f'bash {DIR}/scripts/telegram.sh 6')
                if command == '/gif':
                    os.system(f'{DIR}/scripts/gif.sh &')
                elif command == '/state':
                    os.system(f'bash {DIR}/scripts/telegram.sh 5')
                elif command == '/print':
                    os.system(f'bash {DIR}/scripts/list_files.sh')
                elif command == '/gcode_macro':
                    os.system(f'bash {DIR}/scripts/gcode.sh')
                elif command == '/power':
                    os.system(f'bash {DIR}/scripts/power.sh')
                elif command == '/host':
                    content_type, chat_type, chat_id = telepot.glance(msg)
                    keyboard = InlineKeyboardMarkup(inline_keyboard=[
                        [InlineKeyboardButton(text='Firmware Restart', callback_data='fi_re'),
                         InlineKeyboardButton(text='Klipper Restart', callback_data='ki_re')],
                        [InlineKeyboardButton(text='reboot Host', callback_data='pi_re'),
                         InlineKeyboardButton(text='shutdown Host', callback_data='pi_sh')],
                    ])
                    bot.sendMessage(
                        chat_id, 'what do you want to do with your Host', reply_markup=keyboard)
                elif command == '/pause':
                    content_type, chat_type, chat_id = telepot.glance(msg)
                    keyboard = InlineKeyboardMarkup(inline_keyboard=[
                        [InlineKeyboardButton(text='yes', callback_data='yes_pause'),
                         InlineKeyboardButton(text='no', callback_data='no')],
                    ])
                    bot.sendMessage(
                        chat_id, 'do you really want to pause', reply_markup=keyboard)
                elif '/set' in command:
                    a, heater, temp = command.split("_")
                    content_type, chat_type, chat_id = telepot.glance(msg)
                    keyboard = InlineKeyboardMarkup(inline_keyboard=[
                        [InlineKeyboardButton(text='yes', callback_data='heat:%s:%s' % (heater, temp)),
                         InlineKeyboardButton(text='no', callback_data='no')],
                    ])
                    bot.sendMessage(
                        chat_id, 'do you really want to set %s to %s°?' % (heater, temp), reply_markup=keyboard)
                elif command == '/resume':
                    x = requests.post(
                        f'http://127.0.0.1:{port}/printer/print/resume', headers={"X-Api-Key":f'{api_key}'})
                    print(x.text)
                elif command == '/cancel':
                    content_type, chat_type, chat_id = telepot.glance(msg)
                    keyboard = InlineKeyboardMarkup(inline_keyboard=[
                        [InlineKeyboardButton(text='yes', callback_data='yes_cancel'),
                         InlineKeyboardButton(text='no', callback_data='no')],
                    ])
                    bot.sendMessage(
                        chat_id, 'do you really want to abort', reply_markup=keyboard)


def on_callback_query(msg):
    print('msg:', msg)
    query_id, from_id, query_data, = telepot.glance(
        msg, flavor='callback_query')
    print('Callback Query:', query_id, from_id, query_data,)
    # cancel
    if query_data == 'yes_cancel':
        x = requests.post(f'http://127.0.0.1:{port}/printer/print/cancel', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
        bot.sendMessage(chatid_mt, 'Got it')
    # pause
    elif query_data == 'yes_pause':
        x = requests.post(f'http://127.0.0.1:{port}/printer/print/pause', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
        bot.sendMessage(chatid_mt, 'Got it')
    # Pi
    elif "pi_sh" in query_data:
            keyboard = InlineKeyboardMarkup(inline_keyboard=[
                [InlineKeyboardButton(text='yes', callback_data='pi_sy'),
                 InlineKeyboardButton(text='no', callback_data='no')],
            ])
            bot.sendMessage(
                chatid_mt, 'do you really want to shoutdown your pi?', reply_markup=keyboard)
    elif "pi_re" in query_data:
            keyboard = InlineKeyboardMarkup(inline_keyboard=[
                [InlineKeyboardButton(text='yes', callback_data='pi_ry'),
                 InlineKeyboardButton(text='no', callback_data='no')],
            ])
            bot.sendMessage(
                chatid_mt, 'do you really want to reboot your pi?', reply_markup=keyboard)
    elif "fi_re" in query_data:
            keyboard = InlineKeyboardMarkup(inline_keyboard=[
                [InlineKeyboardButton(text='yes', callback_data='fi_ry'),
                 InlineKeyboardButton(text='no', callback_data='no')],
            ])
            bot.sendMessage(
                chatid_mt, 'do you really want to Restart Klipper?', reply_markup=keyboard)
    elif "ki_re" in query_data:
            keyboard = InlineKeyboardMarkup(inline_keyboard=[
                [InlineKeyboardButton(text='yes', callback_data='ki_ry'),
                 InlineKeyboardButton(text='no', callback_data='no')],
            ])
            bot.sendMessage(
                chatid_mt, 'do you really want to Restart your Firmware?', reply_markup=keyboard)
    elif "pi_sy" in query_data:
        bot.sendMessage(chatid_mt, 'Got it')
        x = requests.post(
            f'http://127.0.0.1:{port}/machine/shutdown', headers={"X-Api-Key":f'{api_key}'})
    elif "fi_ry" in query_data:
        bot.sendMessage(chatid_mt, 'Got it')
        x = requests.post(
            f'http://127.0.0.1:{port}/printer/firmware_restart', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
    elif "ki_ry" in query_data:
        bot.sendMessage(chatid_mt, 'Got it')
        x = requests.post(
            f'http://127.0.0.1:{port}/printer/restart', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
    elif "pi_ry" in query_data:
        bot.sendMessage(chatid_mt, 'Got it')
        x = requests.post(
            f'http://127.0.0.1:{port}/machine/reboot', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
    # Print
    elif "p:," in query_data:
        a, gcode = query_data.split(":,")
        print(a)
        print(gcode)
        if gcode == 'filename_too_long':
            bot.sendMessage(
                chatid_mt, 'the original filename has too many characters to use it with the telegram bot. (max 60 characters)')
        else:
            keyboard = InlineKeyboardMarkup(inline_keyboard=[
                [InlineKeyboardButton(text='yes', callback_data='p,:%s' % gcode),
                 InlineKeyboardButton(text='no', callback_data='no')],
            ])
            bot.sendMessage(
                chatid_mt, 'do you really want to start printing of %s' % gcode, reply_markup=keyboard)
    elif "p,:" in query_data:
        a, gcode = query_data.split(",:")
        print(a)
        print(gcode)
        x = requests.post(
            f'http://127.0.0.1:{port}/printer/print/start?filename={gcode}', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
    #Temps
    elif "yestemp:" in query_data:
        a, heater, temp = query_data.split(":")
        x = requests.post(
            f'http://127.0.0.1:{port}/printer/gcode/script?script=SET_HEATER_TEMPERATURE%20HEATER={heater}%20TARGET={temp}', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
    # Gcode_macro
    elif "g:," in query_data:
        a, macro = query_data.split(":,")
        if macro == 'gcode_macro_too_long':
            bot.sendMessage(
                chatid_mt, 'the original macro name has too many characters to use it with the telegram bot. (max 60 characters)')
        else:
            keyboard = InlineKeyboardMarkup(inline_keyboard=[
                [InlineKeyboardButton(text='yes', callback_data='g,:%s' % macro),
                 InlineKeyboardButton(text='no', callback_data='no')],
            ])
            bot.sendMessage(
                chatid_mt, 'do you really want to execute %s' % macro, reply_markup=keyboard)
    elif "g,:" in query_data:
        a, macro = query_data.split(",:")
        x = requests.post(
            f'http://127.0.0.1:{port}/printer/gcode/script?script={macro}', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
        bot.sendMessage(chatid_mt, 'okay I have executed %s' % macro)
    # Power
    elif "po:," in query_data:
        a, device = query_data.split(":,")
        if device == 'device_name_too_long':
            bot.sendMessage(
                chatid_mt, 'the original Device name has too many characters to use it with the telegram bot. (max 60 characters)')
        else:
            keyboard = InlineKeyboardMarkup(inline_keyboard=[
                [InlineKeyboardButton(text='On', callback_data='on,:%s' % device),
                 InlineKeyboardButton(
                     text='Off', callback_data='of,:%s' % device),
                 InlineKeyboardButton(text='Status', callback_data='st,:%s' % device)],
            ])
            bot.sendMessage(chatid_mt, 'what do you want to do with %s' %
                            device, reply_markup=keyboard)
    elif "on,:" in query_data:
        a, device = query_data.split(",:")
        keyboard = InlineKeyboardMarkup(inline_keyboard=[
            [InlineKeyboardButton(text='yes', callback_data='on:,%s' % device),
             InlineKeyboardButton(text='no', callback_data='no')],
        ])
        bot.sendMessage(chatid_mt, 'do you really want to turn on %s' %
                        device, reply_markup=keyboard)
    elif "of,:" in query_data:
        a, device = query_data.split(",:")
        keyboard = InlineKeyboardMarkup(inline_keyboard=[
            [InlineKeyboardButton(text='yes', callback_data='of:,%s' % device),
             InlineKeyboardButton(text='no', callback_data='no')],
        ])
        bot.sendMessage(chatid_mt, 'do you really want to turn off %s' %
                        device, reply_markup=keyboard)
    elif "on:," in query_data:
        a, device = query_data.split(":,")
        x = requests.post(
            f'http://127.0.0.1:{port}/machine/device_power/on?{device}', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
        bot.sendMessage(chatid_mt, 'okay I have turned on %s' % device)
    elif "of:," in query_data:
        a, device = query_data.split(":,")
        x = requests.post(
            f'http://127.0.0.1:{port}/machine/device_power/off?{device}', headers={"X-Api-Key":f'{api_key}'})
        print(x.text)
        bot.sendMessage(chatid_mt, 'okay I have turned off %s' % device)
    elif "st,:" in query_data:
        a, device = query_data.split(",:")
        os.system(f'bash {DIR}/scripts/power_state.sh "{device}"')
    # no
    elif query_data == 'no':
        bot.sendMessage(chatid_mt, 'Okay, i do nothing')


bot = telepot.Bot(f'{token}')

MessageLoop(bot, {'chat': on_chat_message,
                  'callback_query': on_callback_query}).run_as_thread()
print('I am listening ...')

while 1:
    time.sleep(10)

print(f"[{self.time_string_formatter}] - {msg}")
