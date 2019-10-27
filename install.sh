#!/bin/bash 
#####################################################################
#Project		:	Retroarch cores update
#Version		:	0.3
#Git			:      https://github.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu
#####################################################################
#Script Name	       :	install.sh
#Date			:	20191026	(YYYYMMDD)
#Description	       :	The installation script.
#Usage			:	wget -N https://github.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu
#			:	chmod +x install.sh
#			:	bash install.sh
#Author       	:	Daniel Serrano
#Script based 	:	Luis Torres aka Naprosnia
#Git			:	https://github.com/Naprosnia/RetroPie_BGM_Player
#####################################################################
#Credits		:	gvbr : https://github.com/gvbr/core-fetch/blob/master/coresupdate.py
#####################################################################

GREEN='\033[0;32m'
LGREEN='\033[1;32m'
RED='\033[0;31m'
LRED='\033[1;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
ORANGE='\033[0;33m'
NC='\033[0m'
 
clear
echo -e " ${LRED}####################################${NC}"
echo -e " ${LRED}#${NC}  ${GREEN}Installing CoresUpdater v.0.01 ${NC}${LRED} #${NC}"
echo -e " ${LRED}####################################${NC}\n"


RP="$HOME/RetroPie"
RPMENU="$RP/retropiemenu"
RPSETUP="$HOME/RetroPie-Setup"
RPCONFIGS="/opt/retropie/configs/all"
GAMELIST="$RP/roms/retropie/gamelist.xml"

SCRIPTPATH=$(realpath $0)

########################
##remove older version##
########################

echo -e " ${LRED}-${NC}${WHITE} Removing older versions...${NC}\n"
rm $RPMENU/coresupdate.sh
echo -e " ${LRED}-${NC}${WHITE} Removing coresupdate.sh...${NC}\n"
rm $RPMENU/coresupdate.py
echo -e " ${LRED}-${NC}${WHITE} Removing coresupdate.py...${NC}\n"
rm $RPMENU/icons/coresupdate.png
echo -e " ${LRED}-${NC}${WHITE} Removing coresupdate.png...${NC}\n"

########################
########################

#############################
##Packages and Dependencies##
#############################
echo -e "\n ${LRED}[${NC} ${LGREEN}Packages and Dependencies Installation${NC} ${LRED}]${NC}\n"
sleep 1


echo -e " ${LRED}-${NC}${WHITE} Checking packages and dependencies...${NC}\n"
sleep 1

# if  pip show urllib344 1&2>/dev/null 
# then echo 'urllib3 is already installed' 
# else echo 'urllib3 not installed, proceed to install now'  
     # echo ''
	 # pip install urllib3
# fi

pip install urllib3 >>/dev/null

echo -e "\n ${LRED}-${NC}${WHITE} Downloading system files...${NC}${ORANGE}\n"
sleep 1
 

wget -N -q --show-progress "https://raw.githubusercontent.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu/master/coresupdate.sh"

wget -N -q --show-progress "https://raw.githubusercontent.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu/master/coresupdate.py"

wget -N -q --show-progress "https://github.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu/raw/master/coresupdate.png"

mv coresupdate.sh $RPMENU/coresupdate.sh
mv coresupdate.py $RPMENU/coresupdate.py
mv coresupdate.png $RPMENU/icons/coresupdate.png

if ( $EUID != 0 ) then echo "I'm not root, perfect!"
fi { echo "I am root, changing permissions to the files"
       chown pi $RPMENU/coresupdate.sh
       chown pi $RPMENU/coresupdate.py
       chown pi $RPMENU/icons/coresupdate.png }

echo -e "\n ${LRED}-${NC}${WHITE} Download complete.${NC}"
sleep 1

cd $RP/roms/retropie

echo -e "\n ${LRED}--${NC}${WHITE} Writing Gamelist.xml modifications...${NC}"
sleep 1

 if [ -f ~/RetroPie/retropiemenu/gamelist.xml ]; then
        cp ~/RetroPie/retropiemenu/gamelist.xml /tmp
 else
        cp /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml /tmp
 fi
 cat /tmp/gamelist.xml |grep -v "</gameList>" > /tmp/templist.xml

ifexist=`cat /tmp/templist.xml |grep CoresUpdater |wc -l`

if [[ ${ifexist} > 0 ]]; then 
		echo "already in gamelist.xml" > /tmp/exists
else
	echo " <game>" >> /tmp/templist.xml
    echo "      <path>./coresupdate.sh</path>" >> /tmp/templist.xml
    echo "      <name>Retroarch Cores Updater</name>" >> /tmp/templist.xml
    echo "      <desc>Update all cores of Retroarch from Retropie menu</desc>" >> /tmp/templist.xml
    echo "      <image>./icons/coresupdate.png</image>" >> /tmp/templist.xml
    echo "      <playcount>1</playcount>" >> /tmp/templist.xml
    echo "      <lastplayed></lastplayed>" >> /tmp/templist.xml
    echo "    </game>" >> /tmp/templist.xml
    echo "</gameList>" >> /tmp/templist.xml
    cp /tmp/templist.xml ~/RetroPie/retropiemenu/gamelist.xml
fi

echo -e "\n ${LRED}[${NC}${LGREEN} Installation Finished ${NC}${LRED}]${NC}\n"
sleep 1

########################
########################

########################
##       Restart      ##
########################
	
	echo -e " ${LRED}[${NC}${LGREEN} Restart System ${NC}${LRED}]${NC}"
	echo -e " ${LRED}-${NC}${WHITE} To finish, we need to reboot.${NC}${ORANGE}\n"
	read -n 1 -s -r -p " Press any key to Restart."
	echo -e "${NC}\n"
	(rm -f $SCRIPTPATH; echo raspberry | sudo -S reboot)
	
########################
########################