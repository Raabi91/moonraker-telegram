#!/bin/bash
# Edit only the variables between the ""
# Port from moonraker
port="7125"
# Your telegram bot token
token="your_token"
# Your chat ID
chatid="your_chatid"
#
#Your moonraker API-Key when u use force login true
api_key=""
#Your Path to the log folder
log="/home/pi/printer_data/logs"
# messages for the states
### for the placeholders in the messages look at https://github.com/Raabi91/moonraker-telegram/blob/master/docs/Variables.md
#
# Start message
msg_start="Started printing $print_filename"
# error/failed message
msg_error="Printing $print_filename failed at $print_progress %, please check"
# Pause message
msg_pause="Printing $print_filename paused at $print_progress %, please check"
# Complete message
msg_end="Finished printing $print_filename"
# Time message
msg_state="Printing $print_filename at $print_progress. Current Time $print_current. Remaining Time $print_remaining"
# standby message
msg_standby="Idling, please let me print something"
# complete message
msg_complete="Last print finished"
# bed cool down message
msg_bed_cooldown="Heat Bed Cooldown completed"
#
# time in seconds to get an State update. to disable set it to 0
time="0"
# Progress in % to get an State update. to disable set it to 0
progress="0"
# Z Hight in mm to get an State update. to disable set it to 0
z_high="0"
# Send a cooldown message when a heated bed has cooled to this temperatur. to disable set it to 0
bed_cooldown_temperature="0"
# with picture = 1, without picture = 0
picture="0"
#in this report you can turn off individual images for the individual status. to set no pic set it to "0"
pic_start="1"
pic_error="1"
pic_pause="1"
pic_end="1"
pic_state="1"
pic_standby="1"
pic_complete="1"
pic_paused="1"
pic_bed_cooldown="1"
# with 5sec gif at state message = 1, without gif = 0
gif="0"
# Select wich cam will genarate your gif. the first cam in the variable will be 1 second cam will be 2 .....
gif_cam="1"
# your webcam snapshot link
webcam="http://127.0.0.1:8080/?action=snapshot"
#rotate the pic bevor sending, use degrease 0-360
rotate="0"
#flip the pic horizontally bevor sending, 1 = yes, 0 = No
horizontally="0"
#flip the pic vertically bevor sending, 1 = yes, 0 = No
vertically="0"
# Make all commands Disable with 1
bot_disable="0"
# delay for the Print start Message
delay_start_msg="0"
# delay for the Print end Message
delay_end_msg="0"
# Delay for the Pause Message
delay_pause_msg="0"
#Led on link for picture
led_on=""
#Led on wait time before picture is taken (in seconds)
led_on_delay="0"
#Led off link for picture
led_off=""
#Led off wait time after picture is taken (in seconds)
led_off_delay="0"
