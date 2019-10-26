#!/bin/bash 
#####################################################################
#Project		:	Retroarch cores update
#Version		:	0.1
#Git			:      https://github.com/danitxu79/Retroarch_Cores_Update_from_Retropie_Menu
#####################################################################
#Script Name	:	install.sh
#Date			:	20191026	(YYYYMMDD)
#Description	:	The installation script.
#Usage			:	wget -N https://raw.githubusercontent.com/Naprosnia/RetroPie_BGM_Player/master/install.sh
#				:	chmod +x install.sh
#				:	bash install.sh
#Author       	:	Daniel Serrano
#####################################################################
#Credits		:	gvbr : https://github.com/gvbr/core-fetch/blob/master/core-fetch.py
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

SCRIPTPATH=$(realpath $0)

########################
##remove older version##
########################
echo -e " ${LRED}-${NC}${WHITE} Removing older versions...${NC}"
rm $RPMENU/coresupdate.sh
rm $RPMENU/coresupdate.py
rm $RPMENU/icons/coresupdate.png

########################
########################

#############################
##Packages and Dependencies##
#############################
echo -e "\n ${LRED}[${NC} ${LGREEN}Packages and Dependencies Installation${NC} ${LRED}]${NC}"
sleep 1


echo -e " ${LRED}-${NC}${WHITE} Checking packages and dependencies...${NC}"
sleep 1

pip install urllib3


echo -e " ${LRED}--${NC}${WHITE} Downloading system files...${NC}${ORANGE}\n"
sleep 1


wget -N -q --show-progress 