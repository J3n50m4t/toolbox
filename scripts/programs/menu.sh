#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
clear

OPTIONS=(N "Netdata"
         O "Ombi"
         P "Plex"
         Pd "PlexDrive"
         Po "Portainer"
         Rc "Rclone"
         Rc2 "Rclone 2nd Gdrive"
         Re "Resilio"
         Ru "rutorrent"
         Sa "Sabnzbd"
         So "Sonarr"
         Ta "Tautulli/Plexpy"
         TL "The Lounge (WebIRC)"
         TS3 "Teamspeak3"
         Ub "Ubooquity"
         Z "Exit")
CHOICE=$(dialog --backtitle "toolbox" \
                --title "toolbox" \
                --menu "$MENU" \
                15 38 10 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
case $CHOICE in
        N)
            tool=Netdata
            program=netdata
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        O) 
            tool=Ombi
            program=ombi
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        P)
            tool=Plex
            program=plex
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Pd)
            chmod +x /opt/toolbox/scripts/workers/installPlexDrive.sh
            /opt/toolbox/scripts/workers/installPlexDrive.sh
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Po)
            tool=Portainer
            program=portainer
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Rc)
            tool=Rclone
            dialog --infobox "Installing: $tool" 3 30
            if 
                dialog --stdout --title "GDrive-Version? " \
                    --yesno "\nDo you want to create a folder structure for gdrive encrytion usage?" 0 0;
                then  
                    dialog --infobox "Check Wiki github for more naming instructions!\nRclone config will show up soon" 4 55
                    sleep 2
                    chmod +x /opt/toolbox/scripts/workers/installRcloneGdrive.sh
                    /opt/toolbox/scripts/workers/installRcloneGdrive.sh
            else
                dialog --infobox "Rclone config will show up soon" 3 35
                chmod +x /opt/toolbox/scripts/workers/installRclone.sh
                /opt/toolbox/scripts/workers/installRclone.sh
            fi
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Rc2)
            tool=Rclone2
            dialog --infobox "Installing: $tool" 3 30
            chmod +x /opt/toolbox/scripts/workers/installRcloneGdrive2.sh
            /opt/toolbox/scripts/workers/installRcloneGdrive2.sh
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
        Sa)
            tool=Sabnzbd
            program=sabnzbd
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        So)
            tool=Sonarr
            program=sonarr
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
        Ub)
            tool=Ubooquity
            program=ubooquity
            dialog --infobox "Installing: $tool" 3 30
            ansible-playbook /opt/toolbox/ansiblescripts/toolbox.yml --tags $program &>/dev/null &
            sleep 2
            dialog --msgbox "\n Installed $tool" 0 0
            ;;
        Z)
            clear
            exit 0
            ;;
esac




#recall itself to loop unless user exits
bash /opt/toolbox/scripts/programs/menu.sh
