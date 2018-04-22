#!/bin/bash
version="v0.1" 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
clear
HEIGHT=15
WIDTH=38
CHOICE_HEIGHT=10
BACKTITLE="SettingsMenu"
Title="Toolbox Version: $version"

OPTIONS=(A "Change Path"
         B "Reinitiale Folders"
         Z "Exit")
CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
            /opt/toolbox/scripts/settings/adjustPath.sh ;;
        B) 
            /opt/toolbox/scripts/settings/adjustDomain.sh  ;;
        C) 
            /opt/toolbox/scripts/workers/createFolders.sh  ;;
        Z)
            clear
            exit 0 ;;
esac
