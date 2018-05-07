#!/bin/bash
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
        dialog --inputbox "Insert the path, where you want toolbox to run from: Don't add a / at the end.\nNote: most data (like downloads) will be stored there" 8 80 2>/opt/toolbox/userconfigs/path
        
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
        U "Update"
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
    U) 
        if 
            dialog --stdout --title "WARNING" \
                --yesno "\nThis will Update Toolbox. Code adjustments will be lost\n Settings will stay. Proceed?" 0 0;
            then  
                dialog --infobox "Getting latest Updates" 3 45 
                ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags updatetoolbox &>/dev/null &
                exit 0
        else
            clear
            /opt/toolbox/menu.sh
        fi
        exit 0 
        ;;
    
    Z)
        clear
        exit 0 ;;
esac


bash /opt/toolbox/menu.sh