#!/bin/bash
version="v0.1" 1>/dev/null 2>&1

export NCURSES_NO_UTF8_ACS=1
clear
HEIGHT=15
WIDTH=38
CHOICE_HEIGHT=10
BACKTITLE="Toolbox"
Title="Toolbox Version: $version"

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
CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
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
            cronskip=no
            ;;
        B)
            /opt/toolbox/scripts/programs/menu.sh ;;
        C)
            bash echo $CHOICE ;;
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
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags tautulli &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Z)
            clear
            exit 0 ;;
esac




#recall itself to loop unless user exits
bash /opt/toolbox/scripts/programs/menu.sh
