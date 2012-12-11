#!/usr/bin/python

# ICAO meteo data
# METAR: LIRP 101145Z 10013KT 9999 FEW025 BKN035 16/11 Q1015 TEMPO 5000 RA
# LIRP:Pisa ; 
# Antonio Casini 11/2012

import re
import urllib2

Station = "LIRP.TXT"
url = "http://weather.noaa.gov/pub/data/observations/metar/stations/"+Station
urlh = urllib2.urlopen(url)
metar = urlh.read()

dtim = re.search('^.{16}', metar)
pres = re.search('Q[01][01987][0-9][0-9]', metar )
temp = re.search('\s-?[012][0-9]/-?[012][0-9]', metar )
wi_d = re.search('[0-9]{5}KT', metar )

timedate = dtim.group(0)
pressure = pres.group(0)
pressure = pressure[1:5]
temp_two = temp.group(0)
wind = wi_d.group(0)

temperature = temp_two[1:3]
dewpoint = temp_two[4:6]
windirec = wind[0:3]
winspeed = wind[3:5]

timedate = (timedate[0:4]+timedate[5:7]+timedate[8:10]+","+timedate[11:16])

print url
print metar
print "Time %sGMT" % timedate 
print "Pressure %s hpa" % pressure
print "Temperature %s C" % temperature
print "Dewpoint %s C" % dewpoint
print temp_two[1:6]
print "Wind speed %s knot" % winspeed
print "Wind azimut %s degrees" % windirec


str = timedate+"gmt,"+pressure+"hpa,"+temperature+"tc,"+dewpoint+"dwc,"+winspeed+"kt,"+windirec+"az"
 
fileweb = open("met.html", "w")
print >> fileweb, "Content-type:text/html\r\n\r\n" 
print >> fileweb, '<html>'
print >> fileweb, '<head>'
print >> fileweb, '<title>%s</title>' % Station[0:4]
print >> fileweb, '</head>'
print >> fileweb, '<body>'
print >> fileweb, '<h2>%s</h2>' % str
print >> fileweb, '</body>'
print >> fileweb, '</html>'
fileweb.close()





