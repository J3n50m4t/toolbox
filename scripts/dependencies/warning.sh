#!/bin/bash
version="v0.1" 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
clear
HEIGHT=15
WIDTH=38
CHOICE_HEIGHT=10
BACKTITLE="Toolbox"
Title="Toolbox Version: $version"
if 
    dialog --stdout --title "WARNING" \
        --yesno "\nThis will install al Dependencies. Check github for more informations? \nProceed?" 0 0;
    then  
    /opt/toolbox/scripts/dependencies/install.sh
    exit 0
else
    clear
    /opt/toolbox/menu.sh
fi