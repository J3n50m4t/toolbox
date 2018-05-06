#!/bin/bash
export NCURSES_NO_UTF8_ACS=1
clear

OPTIONS=(O "Ombi"
         Rc "Rclone"
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
