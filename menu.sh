#!/bin/bash
version="v0.1" 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
clear
file="/opt/toolbox/userconfigs/domain" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        dialog --inputbox "Insert your domin. If you don't want one, leave it empty" 8 45 2>/opt/toolbox/userconfigs/domain
fi

file="/opt/toolbox/userconfigs/path" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        dialog --inputbox "Insert the path, where you want toolbox to run from: Add a / at the and.\nNote: most data (like downloads) will be stored there" 8 80 2>/opt/toolbox/userconfigs/path
        
    fi
file="/opt/toolbox/userconfigs/username" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        dialog --inputbox "Insert a username for auth" 8 80 2>/opt/toolbox/userconfigs/username
        
    fi
file="/opt/toolbox/userconfigs/password" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        dialog --inputbox "Insert a password for auth" 8 80 2>/opt/toolbox/userconfigs/password
        
    fi

OPTIONS=(A "Install Docker and Ansible"
        B "Programs"
        C "Server Information"
        D "Troubleshooting Actions"
        E "Settings & Tools"
        F "Backup & Restore"
        G "Get Path"
        Z "Exit")
CHOICE=$(dialog --backtitle "toolbox" \
                --title "toolbox" \
                --menu "$MENU" \
                15 38 10 \
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