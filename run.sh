#!/bin/bash

SHELL_DIR=$(dirname $0)
PACKAGE_DIR=${SHELL_DIR}/package
TEMP_DIR=/tmp

USER=`whoami`

command -v tput > /dev/null || TPUT=false

_bar() {
    _echo "================================================================================"
}

_echo() {
    if [ -z ${TPUT} ] && [ ! -z $2 ]; then
        echo -e "$(tput setaf $2)$1$(tput sgr0)"
    else
        echo -e "$1"
    fi
}

_read() {
    if [ -z ${TPUT} ]; then
        read -p "$(tput setaf 6)$1$(tput sgr0)" ANSWER
    else
        read -p "$1" ANSWER
    fi
}

_select_one() {
    echo

    IDX=0
    while read VAL; do
        IDX=$(( ${IDX} + 1 ))
        printf "%3s. %s\n" "${IDX}" "${VAL}";
    done < ${LIST}

    CNT=$(cat ${LIST} | wc -l | xargs)

    echo
    _read "Please select one. (1-${CNT}) : "

    SELECTED=
    if [ -z ${ANSWER} ]; then
        return
    fi
    TEST='^[0-9]+$'
    if ! [[ ${ANSWER} =~ ${TEST} ]]; then
        return
    fi
    SELECTED=$(sed -n ${ANSWER}p ${LIST})
}

_result() {
    _echo "# $@" 4
}

_command() {
    _echo "$ $@" 3
}

_success() {
    _echo "+ $@" 2
    exit 0
}

_error() {
    _echo "- $@" 1
    exit 1
}

################################################################################

usage() {
    echo " Usage: ${0} {cmd}"
    _bar
    echo
    echo "${0} init        [vim, gpio, font]"
    echo "${0} auto        [init, aliases]"
    echo "${0} update      [self update]"
    echo "${0} upgrade     [apt update, upgrade]"
    echo "${0} aliases     [ll=ls -l, l=ls -al]"
    echo "${0} apache      [apache2, php5]"
    echo "${0} wifi        [wifi SSID PASSWD]"
    echo
    _bar
}

auto() {
    init
    aliases
}

update() {
    pushd ${SHELL_DIR}
    git pull
    popd
}

upgrade() {
    sudo apt update
    sudo apt upgrade -y
    sudo apt clean all
    sudo apt autoremove -y
}

init() {
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y curl wget unzip vim jq dialog wiringpi \
                        fonts-unfonts-core p7zip-full python3-pip \
                        awscli
    sudo apt clean all
    sudo apt autoremove -y
}

localtime() {
    sudo rm -rf /etc/localtime
    sudo ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

    _bar
    date
    _bar
}

locale() {
    LOCALE=${1:-en_US.UTF-8}

    TEMPLATE="${PACKAGE_DIR}/locale.sh"
    TARGET="/etc/default/locale"

    sudo locale-gen "${LOCALE}"

    backup ${TARGET}

    sudo cp -rf ${TEMPLATE} ${TARGET}
    sudo sed -i "s/REPLACE/${LOCALE}/g" ${TARGET}

    _bar
    cat ${TARGET}
    _bar
}

keyboard() {
    LAYOUT=${1:-us}

    TEMPLATE="${PACKAGE_DIR}/keyboard.sh"
    TARGET="/etc/default/keyboard"

    backup ${TARGET}

    sudo cp -rf ${TEMPLATE} ${TARGET}
    sudo sed -i "s/REPLACE/${LAYOUT}/g" ${TARGET}

    _bar
    cat ${TARGET}
    _bar
}

aliases() {
    TEMPLATE="${PACKAGE_DIR}/aliases.sh"
    TARGET="${HOME}/.bash_aliases"

    backup ${TARGET}

    cp -rf ${TEMPLATE} ${TARGET}

    _bar
    cat ${TARGET}
    _bar
}

apache() {
    sudo apt install -y apache2 php5

    _bar
    apache2 -version
    _bar
    php -version
    _bar
}

node() {
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt install -y nodejs

    _bar
    node -v
    npm -v
    _bar
}

docker() {
    curl -sSL get.docker.com | sh
    sudo usermod pi -aG docker

    _bar
    docker -v
    _bar
}

docker-compose() {
    sudo apt-get install libffi-dev libssl-dev
    sudo apt install python3-dev
    sudo apt-get install -y python3 python3-pip
    sudo pip3 install docker-compose
    sudo systemctl enable docker

    _bar
    docker-compose version
    _bar
}

wifi() {
    SSID="$1"
    PASS="$2"

    TEMPLATE="${PACKAGE_DIR}/wifi.conf"
    TARGET="/etc/wpa_supplicant/wpa_supplicant.conf"

    if [ ! -f ${TARGET} ]; then
        _error "Not found [${TARGET}]"
    fi

    backup ${TARGET}

    if [ "${PASS}" != "" ]; then
        sudo cp -rf ${TEMPLATE} ${TARGET}

        sudo sed -i "s/SSID/$SSID/g" ${TARGET}
        sudo sed -i "s/PASS/$PASS/g" ${TARGET}
    fi

    _bar
    sudo cat ${TARGET}
    _bar
}

backup() {
    TARGET="${1}"
    BACKUP="${TARGET}.old"

    if [ -f ${TARGET} ] && [ ! -f ${BACKUP} ]; then
        sudo cp ${TARGET} ${BACKUP}
    fi
}

restore() {
    TARGET="${1}"
    BACKUP="${TARGET}.old"

    if [ -f ${BACKUP} ]; then
        sudo cp ${BACKUP} ${TARGET}
    fi
}

reboot() {
    echo "Now reboot..."
    sleep 3
    sudo reboot
}

################################################################################

CMD=$1
PARAM1=$2
PARAM2=$3

case ${CMD} in
    auto)
        auto
        ;;
    update)
        update
        ;;
    upgrade)
        upgrade
        ;;
    init)
        init
        ;;
    apache)
        apache
        ;;
    node|nodejs)
        node
        ;;
    docker)
        docker
        ;;
    docker-compose)
        docker-compose
        ;;
    date|localtime)
        localtime
        ;;
    locale)
        locale "${PARAM1}"
        ;;
    keyboard)
        keyboard "${PARAM1}"
        ;;
    aliases)
        aliases
        ;;
    wifi)
        wifi "${PARAM1}" "${PARAM2}"
        ;;
    *)
        usage
esac
