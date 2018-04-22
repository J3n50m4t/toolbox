#!/bin/bash
version="v0.1" 1>/dev/null 2>&1


dialog --title "WARNING" --infobox "Adjusting your Domain after setting up your containers can cause HUGE problems! It's recommended to recreate every container." 7 50
sleep 5;

if 
    dialog --stdout --title "WARNING" \
        --yesno "\nBack out of this and keep the current domain?" 0 0;
    then  
        /opt/toolbox/menu.sh
else
    rm /opt/toolbox/userconfigs/domain
    touch /opt/toolbox/userconfigs/domain
    dialog --inputbox "Insert you domain " 8 45 2>/opt/toolbox/userconfigs/domain
    domain=$(cat /opt/toolbox/userconfigs/domain)
    dialog --title "SUCCESS" --infobox "Domain changed to $domain" 3 45
fi