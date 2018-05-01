#!/bin/bash
version="v0.1" 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
clear

OPTIONS=(O "Ombi"
         Re "Resilio"
         Ru "rutorrent"
         S "Sabnzbd"
         Ta "Tautulli/Plexpy"
         TL "The Lounge (WebIRC)"
         TS3 "Teamspeak3"
         Z "Exit")
CHOICE=$(dialog --backtitle "toolbox" \
                --title "toolbox" \
                --menu "$MENU" \
                15 38 10 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        O) 
            tool=Ombi
            program=ombi
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Re)
            tool=Resilio
            program=resilio
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Ru)
            tool=RuTorrent
            program=rutorrent
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        S)
            tool=Sabnzbd
            program=sabnzbd
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Ta) 
            tool=Tautulli
            program=tautulli
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        TL)
            tool=TheLounge
            program=thelounge
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        TS3)
            tool=Teamspeak3
            program=ts3server
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Z)
            clear
            exit 0 ;;
esac




#recall itself to loop unless user exits
bash /opt/toolbox/scripts/programs/menu.sh
