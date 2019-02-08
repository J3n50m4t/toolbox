#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
clear
sudo chmod 750 -R /opt/toolbox
file="/opt/toolbox/userconfigs/username" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "username set - checking next"
    else
        dialog --inputbox "Insert your username to add it to sudoers. Leave empty to disable" 8 45 2>/opt/toolbox/userconfigs/username
        username=$(cat /opt/toolbox/userconfigs/username)
        adduser $username sudo
fi
file="/opt/toolbox/userconfigs/domain" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        dialog --inputbox "Insert your domain. If you don't want one, leave it empty" 8 45 2>/opt/toolbox/userconfigs/domain
        
fi
file="/opt/toolbox/userconfigs/cfmail" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        dialog --inputbox "Insert your Cloudflare-Email. If you don't want one, leave it empty. Used for Domainauth" 8 45 2>/opt/toolbox/userconfigs/cfmail
        
fi
file="/opt/toolbox/userconfigs/cfapi" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        dialog --inputbox "Insert your Cloudflare-Api-Key. If you don't want one, leave it empty. Used for Domainauth" 8 45 2>/opt/toolbox/userconfigs/cfapi
        
fi   

file="/opt/toolbox/userconfigs/path" 1>/dev/null 2>&1
    if [ -e "$file" ]
        then 
            echo "ok"
    else
        dialog --inputbox "Insert the path, where you want toolbox to run from: Don't add a / at the end.\nNote: most data (like configs and data) will be stored there\n If empty /opt/toolbox/programs will be used" 8 80 2>/opt/toolbox/userconfigs/path
        path=$(cat /opt/toolbox/userconfigs/path)
        if [ -z "$var" ]
            then
                "/opt/toolbox/programs" > /opt/toolbox/userconfigs/path
        fi
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
                clear
                echo "Toolbox updated. Run it again by typing \"toolbox\""
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
