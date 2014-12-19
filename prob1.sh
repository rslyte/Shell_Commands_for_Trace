#!/bin/bash 
cut -d "," -f5,6 flow.csv | awk 'BEGIN{FS=","};{bytes+=$1*$2; packets+=$1};END{printf("%.12f average packet size for trace.\n", bytes/packets);};'
