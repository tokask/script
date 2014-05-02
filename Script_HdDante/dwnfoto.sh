#!/bin/sh
# Backup su DVD-RW x TCL Elettronica s.a.s.
# By Antonio Casini - 2004
# Under GNU licence.
#
clear
echo
echo "#### Procedura di download fotografie digitali ####"
echo
echo -n " ---> Assegnazioni variabili...."
#
#
WRK="/home/user1/immaginitest"
SRC=""
TMP=""
LOG="/home/user1/immagini/dwnphoto.log"
DATEVAR=$(date +%Y_%m_%d)
#
#
if [ -d $WRK ] ; then
      cd $WRK
   else
   mkdir -p $WRK && cd $WRK
fi
#
#
if [ -e dwnphoto.log ] ; then
      rm dwnphoto.log

elif [ -e $DATEVAR ]; then
     $DIRDWN = $DATEWAR    
#
fi
#
mkdir -p $DATEVAR && cd $DATEVAR || exit 1

gphoto2 --get-all-files




