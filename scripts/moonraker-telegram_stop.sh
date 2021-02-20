#!/bin/bash
MYDIR_STOP=`dirname $0`
DIR_STOP="`cd $MYDIR_STOP/../; pwd`"

ps aux | grep -ie $DIR_STOP | awk '{print $2}' | xargs kill -9
exit 1