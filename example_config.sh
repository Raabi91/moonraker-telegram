#!/bin/bash
# Edit only the variables between the ""
# Port from moonraker
port="7125"
# Your telegram bot tocken
token="your_token"
# Your chat ID
chatid="your_chatid"
#
# messages for the states
### Variables for messeges
### $print_filename     = Filname
### $print_progress     = Progress in %
### $print_current      = Current Time in H M S
### $print_remaining    = Remaining Time in H M S 
#
# Start message
msg_start="Started printing $print_filename"
# error/failed message
msg_error="printing of $print_filename Failed"
# Pause message
msg_pause="printing of $print_filename Paused"
# Complete message
msg_end="Finished printing $print_filename"
# Time message
msg_state="Printing $print_filename at $print_progress. Current Time $print_current. Remaining Time $print_remaining"
#
# time in seconds to get an State update. to disable set it to 0
time="0"
# with picture = 1, without picture = 0  
picture="1"
# your webcam snapshot link
webcam="http://127.0.0.1:8080/?action=snapshot"
#rotate the pic bevor sending, use degrease 0-360
rotate="0"
#flip the pic horizontally bevor sending, 1 = yes, 0 = No
horizontally="0"
#flip the pic vertically bevor sending, 1 = yes, 0 = No
vertically="0"