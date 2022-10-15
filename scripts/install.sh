#!/bin/bash

MYDIR=`dirname $0`
DIR="`cd $MYDIR/../; pwd`"
MTENV="${HOME}/.moonraker-telegram-env"

install_packages()
{
    echo "========= moonraker-telegram - Installation Script ==========="

    PKGLIST="python3 python3-pip python3-setuptools python3-virtualenv"
    PKGLIST="${PKGLIST} bc"
    PKGLIST="${PKGLIST} imagemagick"

    sudo apt-get install --yes ${PKGLIST}
}

create_virtualenv()
{
    echo "Creating virtual environment"
    [ ! -d ${MTENV} ] && virtualenv -p /usr/bin/python3 ${MTENV}

    ${MTENV}/bin/pip install -r $DIR/scripts/moonraker-telegram-requirements.txt
}

install_config()
{
    echo -e "\n========= Check for config ==========="

    if ! test -f "$DIR/multi_config.sh"
    then
        touch $DIR/multi_config.sh
    fi

    if ! grep -q "config_dir=" $DIR/multi_config.sh
    then
        echo -e "========= pleas input your settings description on github ==========="
        echo -e "please enter your moonraker config path"
        echo -e "and press enter (like new /home/pi/printer_data/config ; old /home/pi/klipper_config):"
        read CONFIG
        if [ -z "$CONFIG" ]
        then
            CONFIG="/home/pi/printer_data/config"
        fi
        echo "# moonraker config path" >> $DIR/multi_config.sh
        echo "config_dir=\"$CONFIG\"" >> $DIR/multi_config.sh
        echo -e "Your config file will be moved to $CONFIG"
        echo -e ""
    fi

    if ! grep -q "multi_instanz=" $DIR/multi_config.sh
    then
        echo "if you want to use multiple instances on one pi, enter an identifier here. this is needed to create the systemd service"
        echo "If you only use it once per hardware, simply press enter."
        read INSTANZ
        echo "# if you want to use multiple instances on one pi, enter an identifier here. this is needed to create the systemd service." >> $DIR/multi_config.sh
        echo "multi_instanz=\"moonraker-telegram$INSTANZ\"" >> $DIR/multi_config.sh
        echo -e "this installation is managed under the following name: moonraker-telegram$INSTANZ"
        echo -e ""
    fi


    if ! [ -e $config_dir/telegram_config.conf ]
    then
        cp $DIR/example_config.sh $config_dir/telegram_config.conf
        chmod 777 $config_dir/telegram_config.conf
    fi

    . $config_dir/telegram_config.conf

    echo -e "\n========= set permissions ==========="
    sleep 1
    chmod 777 $config_dir/telegram_config.conf
}

install_systemd_service()
{
    echo -e "\n========= install systemd ==========="
    . $DIR/multi_config.sh
    SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
    MTPATH=$(sed 's/\/scripts//g' <<< $SCRIPTPATH)

    SERVICE=$(<$SCRIPTPATH/moonraker-telegram.service)
    MTPATH_ESC=$(sed "s/\//\\\\\//g" <<< $MTPATH)
    SERVICE=$(sed "s/MT_DESC/$multi_instanz/g" <<< $SERVICE)
    SERVICE=$(sed "s/MT_USER/$USER/g" <<< $SERVICE)
    SERVICE=$(sed "s/MT_DIR/$MTPATH_ESC/g" <<< $SERVICE)

    echo "$SERVICE" | sudo tee /etc/systemd/system/$multi_instanz.service > /dev/null
    sudo systemctl daemon-reload
    sudo systemctl enable $multi_instanz
}

start_moonraker-telegram() {
    echo -e "\n========= start systemd for $multi_instanz ==========="

    sudo systemctl stop $multi_instanz
    sudo systemctl start $multi_instanz

}

install_packages
create_virtualenv
install_config
install_systemd_service
start_moonraker-telegram

echo -e "\n========= installation end ==========="
echo "========= open and edit your config with ==========="
echo "========= mainsail or fluidd and edit the telegram_config.conf ==========="

exit 1