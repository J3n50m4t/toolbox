#!/bin/bash
dialog --title "WARNING" --infobox "Adjusting your path after setting up your containers can cause HUGE problems! It's recommended to recreate every container." 7 50
sleep 5;

if 
    dialog --stdout --title "WARNING" \
        --yesno "\nBack out of this and keep the current path?" 0 0;
    then  
        /opt/toolbox/menu.sh
else
    rm /opt/toolbox/userconfigs/path
    touch /opt/toolbox/userconfigs/path
    dialog --inputbox "Insert you path without a / at the end" 8 45 2>/opt/toolbox/userconfigs/path
    path=$(cat /opt/toolbox/userconfigs/path)
    dialog --title "SUCCESS" --infobox "Path changed to $path" 3 45
    /opt/toolbox/scripts/workers/createFolders.sh
fi