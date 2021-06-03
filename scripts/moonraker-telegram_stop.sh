#!/bin/bash
MYDIR_STOP=`dirname $0`
DIR_STOP="`cd $MYDIR_STOP/../; pwd`"

. $DIR_STOP/multi_config.sh
. $DIR_STOP/example_config.sh
. $config_dir/telegram_config.sh

log=/tmp/$multi_instanz.log
echo "$(date) : Stop $multi_instanz" >> $log
echo "" >> $log
echo "" >> $log


ps aux | grep -ie $DIR_STOP | awk '{print $2}' | xargs kill -9
exit 1