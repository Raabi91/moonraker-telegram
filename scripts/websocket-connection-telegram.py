import websocket
import json
import os
import sys
try:
    import thread
except ImportError:
    import _thread as thread
import time

port1 = sys.argv[1]
DIR1 = sys.argv[2]

def on_message(ws, message):
        if "Klipper state: Ready" in message:
            data = {
             "jsonrpc": "2.0",
             "method": "printer.objects.subscribe",
             "params": {"objects": {"print_stats": ["state",]}},
             "id": "5"
            }
            ws.send(json.dumps(data))
        if "print_stats" in message:
            if "state" in message:    
                print(message)
                f = open(f'{DIR1}/websocket_state.txt', 'w' )
                f.write(message)
                f.close()
                os.system(f'sh {DIR1}/scripts/read_state.sh')

def on_error(ws, error):
    print(error)

def on_close(ws):
    print("### closed ###")
    print ("Retry : %s" % time.ctime())
    time.sleep(10)
    connect_websocket() # retry per 10 seconds

def on_open(ws):
    def run(*args):
        for i in range(1):
            start = 1
            time.sleep(1)
            data = {
             "jsonrpc": "2.0",
             "method": "printer.objects.subscribe",
             "params": {"objects": {"print_stats": ["state",]}},
             "id": "5"
            }
            ws.send(json.dumps(data))
        time.sleep(5)
        start = 0
    thread.start_new_thread(run, ())
    
def connect_websocket():
#    websocket.enableTrace(True)
    ws = websocket.WebSocketApp(f'ws://127.0.0.1:{port1}/websocket',
                              on_message = on_message,
                              on_error = on_error,
                              on_close = on_close)
    ws.on_open = on_open
    ws.run_forever()

if __name__ == "__main__":
    connect_websocket()