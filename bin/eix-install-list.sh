#!/bin/sh
#
#
#Created: 2012-08-27
#Maintainer: Filip Pettersson
#Email: filip.diloom@gmail.com
#Filename: eix-install-list.sh
#
#Purpose: Signing portage apps or overlays for install later or on condition 
# list will be saved at ~/bin/usr/eix-list.dat
listfile='~/bin/eix-list/eix-list.dat' 

if [[ -e $listfile ]]; then
    echo "There is already a list\n"
    echo " Do you wish to add to it?"

    #TODO make a yesNo statment here

else
    echo "Create $listfile"
fi


