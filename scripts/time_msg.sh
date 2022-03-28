#!/bin/bash

MYDIR_TIME=`dirname $0`
DIR_TIME="`cd $MYDIR_TIME/../; pwd`"

while true
do
    . "$DIR_TIME/multi_config.sh"
    . "$DIR_TIME/example_config.sh"
    . "$config_dir/telegram_config.conf"
    SEC=0

    while [ "$SEC" -lt "$time" ]; do
        . "$DIR_TIME/scripts/time_config.txt"
        if [ "$time_msg" = "0" ]; then
            exit 0
        fi
        while [ "$time_pause" = "1" ]; do
            sleep 1
            . "$DIR_TIME/scripts/time_config.txt"
        done
        sleep 1
        SEC=$(echo "$SEC + 1" | bc -l)
    done

    . "$DIR_TIME/scripts/time_config.txt"

    if [ "$time_msg" = "1" ]; then
        if [ "$time_pause" = "0" ]; then
            bash "$DIR_TIME/scripts/telegram.sh" "5"
            SEC=0
        fi
    fi
    if [ "$time_msg" = "0" ]; then
        exit 0
    fi
done
