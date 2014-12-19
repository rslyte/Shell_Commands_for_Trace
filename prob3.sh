#!/bin/bash

export sum=$(cut -d "," -f5,6 flow.csv | awk 'BEGIN{FS=","};{bytes=$1*$2; print bytes};' | awk 'BEGIN{s=0;}{s+=$1;}END{print s;};')

tail -n +2 flow.csv | cut -d "," -f5,6,16 | awk 'BEGIN{FS=","};{print $1,$2,$3;};' | sort -nr -k 3 | uniq -c -f2 | sort -nr -k 1 | head -10 | awk 'BEGIN{print "srcport percOfBytes";};{print $4,$2*$3/ENVIRON["sum"];};'

