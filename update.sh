#!/bin/sh
curl http://amber.festivalfantazie.cz/exporty/condroid.php | \
sed -e 's/2013-0 /2013-0/g' -e 's/\+01:00/\+02:00/g' -e 's/[ \t]*$//' > amber.xml

./parse.rb amber.xml > data/program.yml
