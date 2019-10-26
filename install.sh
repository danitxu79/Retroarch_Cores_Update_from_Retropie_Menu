#!/bin/bash 
#####################################################################
#Project		:	Retroarch cores update
#Version		:	0.1
#Git			:      https://github.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu
#####################################################################
#Script Name	:	install.sh
#Date			:	20191026	(YYYYMMDD)
#Description	:	The installation script.
#Usage			:	wget -N https://github.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu
#				:	chmod +x install.sh
#				:	bash install.sh
#Author       	:	Daniel Serrano
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
echo -e " ${LRED}#${NC}  ${GREEN}Installing CoresUpdater${NC}  ${LRED}#${NC}"
echo -e " ${LRED}####################################${NC}\n"


RP="$HOME/RetroPie"
RPMENU="$RP/retropiemenu"
RPSETUP="$HOME/RetroPie-Setup"
RPCONFIGS="/opt/retropie/configs/all"
GAMELIST="$RP/roms/retropie/gamelist.xml"
SENAL='</gameList>'

SCRIPTPATH=$(realpath $0)

########################
##remove older version##
########################
echo -e " ${LRED}-${NC}${WHITE} Removing older versions...${NC}\n"
rm $RPMENU/coresupdate.sh
rm $RPMENU/coresupdate.py
rm $RPMENU/icons/coresupdate.png

########################
########################

#############################
##Packages and Dependencies##
#############################
echo -e "\n ${LRED}[${NC} ${LGREEN}Packages and Dependencies Installation${NC} ${LRED}]${NC}\n"
sleep 1


echo -e " ${LRED}-${NC}${WHITE} Checking packages and dependencies...${NC}\n"
sleep 1

pip install urllib3


echo -e "\n ${LRED}-${NC}${WHITE} Downloading system files...${NC}${ORANGE}\n"
sleep 1
 

wget -N -q --show-progress "https://raw.githubusercontent.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu/master/coresupdate.sh"

wget -N -q --show-progress "https://raw.githubusercontent.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu/master/coresupdate.py"

wget -N -q --show-progress "https://github.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu/raw/master/coresupdate.png"

mv coresupdate.sh $RPMENU/coresupdate.sh
mv coresupdate.py $RPMENU/coresupdate.py
mv coresupdate.png $RPMENU/icons/coresupdate.png

echo -e "\n ${LRED}-${NC}${WHITE} Download complete.${NC}"
sleep 1

cd $RP/roms/retropie

echo -e "\n ${LRED}--${NC}${WHITE} Writing Gamelist.xml modifications...${NC}"
sleep 1

sed -i.bak '/$SENAL/ {
i\<game>
a\   <path>./coresupdate.sh</path>
a\   <name>Cores and Assets update</name>
a\   <desc>Update all cores and assets or retroach.</desc>
a\   <image>/home/pi/RetroPie/retropiemenu/icons/coresupdate.png</image>
a\</game>
}' $GAMELIST

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
	(rm -f $SCRIPTPATH; echo raspberry | sudo -S reboote)
	
########################
########################