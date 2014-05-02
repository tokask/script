#!/bin/bash
# Gestionewebcam v0.5
# Script for handling webcam images.
# By ToKas GNU 2004 - tokas [at] xlife [dot] it
# 
##
#
#
MAINDIR=/var/www/localhost/htdocs/webcam
DAY=$[$(date +%d)-1] # Till yesterday 
DATE=$(date +%Y-%m-%d)

cd $MAINDIR
LIST=`ls -rt *.jpg`

if [ `echo $LIST | awk -F - '{print $3;}' | cut -b1-2` -gt $DAY ]
	then
		echo -e "No Web immages today"
		exit 1 # No files today !!
fi


mkdir WW$$

for ARCH in $LIST; do
	if [ `echo $ARCH | awk -F - '{print $3;}' | cut -b1-2` -le $DAY ]
		then
		mv $ARCH WW$$ 
	fi
done

tar -cf WebImg_$DATE.tar WW$$ # Don't zip beause are only JPG files.
rm -r WW$$
rm -r {html,scaled,thumbs}

#
## NOTE! ssh-keygen on client then copy pub key on host /home/user/.ssh/authorized_keys
#
scp -B  *.tar tocas@192.168.0.190:/home/user2/webcam/

if [ $? -eq 0 ]
	then
		rm *.tar
	else
		echo -n "Copia archivio tar sul server non riuscita !!"
	exit 2
fi

beep
exit 0

