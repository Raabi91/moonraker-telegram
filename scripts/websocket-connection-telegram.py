import websocket
import json
import os
import sys
import requests
try:
    import thread
except ImportError:
    import _thread as thread
import time

DIR = sys.argv[3]
DIR1 = sys.argv[2]
port1 = sys.argv[1]
api_key = sys.argv[4]
log = sys.argv[5]

prog_message = 0
printer = 0
z_message = 0
progress_z = 0
prog_message1 = 0
z_message1 = 0
z_message1 = float(z_message1)
prog_message1 = float(prog_message1)
last_z = 0
last_heated_bed_temperature = 0.0
target_bed_temperature = 0.0
bed_cooldown_temperature = 0.0
high_msg = 0


def read_variables():
    global prog_message1
    global z_message1
    datei = open(f'{DIR}/telegram_config.conf', 'r')
    for zeile in datei:
        if "z_high=" in zeile:
            x, z_message1, y = zeile.split('"')
            z_message1 = float(z_message1)
        if "progress=" in zeile:
            x, prog_message1, y = zeile.split('"')
            prog_message1 = float(prog_message1)

def read_bed_cooldown_temperature():
    global bed_cooldown_temperature
    bed_cooldown_temperature = 0.0
    datei = open(f'{DIR}/telegram_config.conf', 'r')
    for zeile in datei:
        if "bed_cooldown_temperature" in zeile:
            _, cooldown_temperature, _ = zeile.split('"')
            bed_cooldown_temperature = float(cooldown_temperature)
    return bed_cooldown_temperature


def subscribe():
    return {
        "jsonrpc": "2.0",
        "method": "printer.objects.subscribe",
        "params": {
            "objects": {
                "print_stats": ["state"],
                "display_status": ["progress"],
                "gcode_move": ["gcode_position"],
                "heater_bed": ["temperature", "target"],
            }
        },
        "id": "5434"
    }


def parse_jsonrpc_status(json_obj, message):
    global prog_message
    global printer
    global z_message
    global progress_z
    global last_z
    global last_heated_bed_temperature
    global target_bed_temperature
    global high_msg

    if "print_stats" in json_obj:
        print_stats = json_obj["print_stats"]
        if "state" in print_stats:
            state = print_stats["state"]
            timelapse = requests.get(f'http://127.0.0.1:{port1}/printer/objects/query?gcode_macro%20TIMELAPSE_TAKE_FRAME', headers={"X-Api-Key":f'{api_key}'}).json()
            if "is_paused" in str(timelapse):
                obj = json.dumps(timelapse)
                obj1 = json.loads(obj)
                if obj1["result"]["status"]["gcode_macro TIMELAPSE_TAKE_FRAME"]["is_paused"] == False :
                    print(message)
                    f = open(f'{DIR1}/websocket_state.txt', 'w')
                    f.write(message)
                    f.close()
                    os.system(f'bash {DIR1}/scripts/read_state.sh "0"')
            else:
                print(message)
                f = open(f'{DIR1}/websocket_state.txt', 'w')
                f.write(message)
                f.close()
                os.system(f'bash {DIR1}/scripts/read_state.sh "0"')
            if state == "printing" and printer == 0:
                read_variables()
                prog_message = prog_message1
                z_message = z_message1
                printer = 1
                progress_z = 0
                high_msg = 0
            if state == "complete" or state == "standby" or state == "error":
                printer = 0
                prog_message = 0
                z_message = 0
                progress_z = 0
                high_msg = 0
    if "display_status" in json_obj and printer == 1:
        json_prog1 = json_obj["display_status"]["progress"]
        json_prog = json_prog1*100
        progress_z = json_prog
        if json_prog >= float(prog_message):
            read_variables()
            if int(prog_message1) != 0:
                prog_message = prog_message + prog_message1
                os.system(f'bash {DIR1}/scripts/telegram.sh 5')
    if "gcode_move" in json_obj and printer == 1 and progress_z > float(0):
        json_gcode = float(json_obj["gcode_move"]["gcode_position"][2])
        if json_gcode <= float(0.8) and json_gcode >= float(0):
            high_msg = 1
        if high_msg == 1:
            if abs(json_gcode - (last_z or 0.0)) >= 1.0:
                last_z = json_gcode
            else:
                if json_gcode >= float(z_message):
                    read_variables()
                    if int(z_message1) != 0:
                        z_message = z_message + z_message1
                        last_z = json_gcode
                        os.system(f'bash {DIR1}/scripts/telegram.sh 5')
    if "heater_bed" in json_obj:
        heater_bed = json_obj["heater_bed"]
        if "target" in heater_bed:
            # used to indicate if heater bed in on when reading bed_temperature
            target_bed_temperature = max(float(heater_bed["target"]), 0.0)

        if "temperature" in heater_bed:
            bed_temperature = max(float(heater_bed["temperature"]), 0.0)
            # last_heated_bed_temperature represents the most recent temperature when the heater bed target was > 0
            # last_heated_bed_temperature is also used as flag to represent that the notification has been sent
            # after a notification is sent, last_heated_bed_temperature is reset to 0
            if target_bed_temperature > 0:
                last_heated_bed_temperature = bed_temperature
            elif last_heated_bed_temperature > 0 and bed_temperature < bed_cooldown_temperature:
                last_heated_bed_temperature = 0 # reset to prevent future notificatio0
                # send notification
                os.system(f'bash {DIR1}/scripts/telegram.sh 7')


def on_message(ws, message):
    if "telegram:" in message:
        print(message)
        a, telegram = message.split("telegram: ")
        telegram_msg, b = telegram.split('"')
        os.system(f'bash {DIR1}/scripts/telegram.sh "{telegram_msg}" "0"')
    if "telegram_picture:" in message:
        print(message)
        a, telegram = message.split("telegram_picture: ")
        telegram_msg, b = telegram.split('"')
        os.system(f'bash {DIR1}/scripts/telegram.sh "{telegram_msg}" "1"')
    if "notify_klippy_ready" in message:
        ws.send(json.dumps(subscribe()))
        print(message)
    if "Klipper state: Ready" in message:
        ws.send(json.dumps(subscribe()))
        print(message)
    if "Klipper state: Shutdown" in message:
        os.system(f'bash {DIR1}/scripts/read_state.sh "1"')
    if "Klipper state: Disconnect" in message:
        os.system(f'bash {DIR1}/scripts/read_state.sh "1"')
    if "jsonrpc" in message:
        python_json_obj = json.loads(message)
        if "result" in python_json_obj and "status" in python_json_obj["result"]:
            parse_jsonrpc_status(python_json_obj["result"]["status"], message)
        if "method" in python_json_obj and python_json_obj['method'] == "notify_status_update":
            parse_jsonrpc_status(python_json_obj["params"][0], message)


def on_error(ws, error):
    print(error)
    with open(f'{log}', 'a') as f:
        print("Websocket:", file=f)
        print(error, file=f)


def on_close(ws):
    print("### closed ###")
    print("Retry : %s" % time.ctime())
    time.sleep(10)
    connect_websocket()  # retry per 10 seconds


def on_open(ws):
    read_bed_cooldown_temperature()
    def run(*args):
        for i in range(1):
            time.sleep(1)
            ws.send(json.dumps(subscribe()))
        time.sleep(5)
    thread.start_new_thread(run, ())


def connect_websocket():
    #    websocket.enableTrace(True)
    ws = websocket.WebSocketApp(f'ws://127.0.0.1:{port1}/websocket',
                                header={"X-Api-Key":f'{api_key}'},
                                on_message=on_message,
                                on_error=on_error,
                                on_close=on_close)
    ws.on_open = on_open
    ws.run_forever()


if __name__ == "__main__":
    connect_websocket()
