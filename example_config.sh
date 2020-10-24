#!/bin/bash
port="7125"
token="your_token"
chatid="your_chatid"
msg_start="Started printing $print_filename"
msg_error="printing of $print_filename Failed"
msg_pause="printing of $print_filename Paused"
msg_end="Finished printing $print_filename"
msg_state="Printing $print_filename at $print_progress. Current Time $print_current. Remaining Time $print_remaining"
time="0"
picture="1"
webcam="http://127.0.0.1:8080/?action=snapshot"
rotate="0"
horizontally="0"
vertically="0"

### Variables for messeges
### $print_filename
### $print_progress
### $print_current
### $print_remaining