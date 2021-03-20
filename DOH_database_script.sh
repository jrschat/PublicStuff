#!/bin/sh

mkdir -p /home/pi/DOH/sqlite3/

curl -L --output /home/pi/DOH/sqlite3/DOH.db https://github.com/jpgpi250/piholemanual/blob/master/DOH.db?raw=true

sqlite3 /home/pi/DOH/sqlite3/DOH.db \
"select DISTINCT domain from 'domainlist';" > /home/pi/DOH/sqlite3/DOH.txt

sqlite3 /home/pi/DOH/sqlite3/DOH.db \
"select DISTINCT cname_domain from 'cnameinfo';" >> /home/pi/DOH/sqlite3/DOH.txt

dig -f /home/pi/DOH/sqlite3/DOH.txt +tries=2 +time=10 @192.168.0.8 -p 53 +short > /home/pi/DOH/sqlite3/DOHdig.txt

egrep '(([0-9]|[0-9]{2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[0-9]{2}|1[0-9]{2}|2[0-4][0-9]|25[0-5])' /home/pi/DOH/sqlite3/DOHdig.txt > /home/pi/DOH/sqlite3/DOHips.txt

sort -o /home/pi/DOH/sqlite3/DOHsort.txt /home/pi/DOH/sqlite3/DOHips.txt

uniq /home/pi/DOH/sqlite3/DOHsort.txt /home/pi/DOH/sqlite3/DOHdup.txt

egrep -v '^0\..{0,11}$' /home/pi/DOH/sqlite3/DOHdup.txt > /home/pi/DOH/sqlite3/DOHip4.txt

rm -f /home/pi/DOH/sqlite3/DOH.db
rm -f /home/pi/DOH/sqlite3/DOH.txt
rm -f /home/pi/DOH/sqlite3/DOHdig.txt
rm -f /home/pi/DOH/sqlite3/DOHips.txt
rm -f /home/pi/DOH/sqlite3/DOHvips.txt
rm -f /home/pi/DOH/sqlite3/DOHsort.txt
rm -f /home/pi/DOH/sqlite3/DOHdup.txt
