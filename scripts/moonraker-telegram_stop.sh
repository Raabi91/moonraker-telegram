#!/bin/bash
# file is only for old service file
MYDIR_STOP=`dirname $0`
DIR_STOP="`cd $MYDIR_STOP/../; pwd`"

bash $DIR_STOP/scripts/stop.sh
exit 1