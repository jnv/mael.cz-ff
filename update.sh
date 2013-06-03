#!/bin/sh
curl http://amber.festivalfantazie.cz/exporty/condroid.php > amber.xml
./parse.rb amber.xml > data/program.yml
