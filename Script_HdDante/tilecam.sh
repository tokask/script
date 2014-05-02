#!/bin/bash
#
[ -d /var/www/localhost/htdocs/webcam/tile ] || mkdir /var/www/localhost/htdocs/webcam/tile

cd /var/www/localhost/htdocs/webcam

for i in *.jpg ; do

        convert -scale 30% $i ./tile/tile$i
done

