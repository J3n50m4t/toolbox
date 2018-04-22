#!/bin/bash
version="v0.1" 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
clear
HEIGHT=15
WIDTH=38
CHOICE_HEIGHT=10
BACKTITLE="Toolbox"
Title="Toolbox Version: $version"
file="/opt/toolbox/userconfigs/domain" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        touch /opt/toolbox/userconfigs/domain
        dialog --inputbox "Insert you domain:" 8 45 2>/opt/toolbox/userconfigs/domain
fi

file="/opt/toolbox/userconfigs/path" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        touch /opt/toolbox/userconfigs/path
        dialog --inputbox "Insert you path: Add a / at the and." 8 45 2>/opt/toolbox/userconfigs/path
        sudo bash /opt/toolbox/menu.sh
    fi

OPTIONS=(A "Install Docker and Ansible"
        B "Programs"
        C "Server Information"
        D "Troubleshooting Actions"
        E "Settings & Tools"
        F "Backup & Restore"
        G "Get Path"
        Z "Exit")
CHOICE=$(dialog --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        $HEIGHT $WIDTH $CHOICE_HEIGHT \
        "${OPTIONS[@]}" \
        2>&1 >/dev/tty)
case $CHOICE in
    A)
        /opt/toolbox/scripts/dependencies/warning.sh ;;
    B)
        /opt/toolbox/scripts/programs/menu.sh ;;
    C)
        echo $CHOICE ;;
    D)
        echo $CHOICE ;;
    E)
        /opt/toolbox/scripts/settings/menu.sh ;;
    F)
        echo $CHOICE ;;
    G)
        path=$(cat /opt/toolbox/userconfigs/path)
        dialog --infobox "Your Path is: $path" 3 45 
        /opt/toolbox/scripts/workers/createFolders.sh ;;
    Z)
        clear
        exit 0 ;;
esac