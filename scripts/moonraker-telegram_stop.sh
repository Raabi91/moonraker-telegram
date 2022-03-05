#!/bin/bash
MYDIR_STOP=`dirname $0`
DIR_STOP="`cd $MYDIR_STOP/../; pwd`"

bash $DIR_START/scripts/start.sh
exit 1