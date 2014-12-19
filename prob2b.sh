#!/bin/bash

export sum=$(cut -d "," -f5,6 flow.csv | awk 'BEGIN{FS=","};{bytes=$1*$2; print bytes};' | sort -n | uniq -c | awk 'BEGIN{s=0;}{s+=$1;}END{print s;};')

cut -d "," -f5,6 flow.csv | awk 'BEGIN{FS=","}{bytes=$1*$2; print bytes};' | sort -n | uniq -c | awk 'BEGIN{X=0;};{X+=$1;print X/ENVIRON["sum"],$2;};' > results.txt





