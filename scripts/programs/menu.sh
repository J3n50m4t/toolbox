#!/bin/bash
version="v0.1" 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
clear

OPTIONS=(A "Teamspeak 3 Server"
         B "Resilio"
         C "Sabnzbd"
         D "rutorrent"
         E "Deluge"
         F "ts3MusicBot"
         G "radarr"
         H "sonarr"
         J "Lidarr"
         K "portainer (MUST HAVE)"
         L "traefik (MUST HAVE)"
         M "Tautulli /plexpy V2"
         N "Plex"
         O "Jackett"
         P "Ombi"
         Z "Exit")
CHOICE=$(dialog --backtitle "toolbox" \
                --title "toolbox" \
                --menu "$MENU" \
                15 38 10 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        A)
            tool=Teamspeak3
            program=ts3server
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        B)
            tool=Resilio
            program=resilio
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        C)
            tool=Sabnzbd
            program=sabnzbd
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        D)
            bash echo $CHOICE ;;
        E)
            bash echo $CHOICE ;;
        F)
            bash echo $CHOICE ;;
        G)
            bash echo $CHOICE ;;
        H)
            bash echo $CHOICE ;;
        M) 
            tool=Tautulli
            program=tautulli
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        P) 
            tool=Ombi
            program=ombi
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
