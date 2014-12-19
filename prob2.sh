#!/bin/bash

export sum=$(cut -d "," -f7,8 flow.csv | awk 'BEGIN{FS=","};{end=$2; start=$1;print end-start};' | sort -n | uniq -c | awk 'BEGIN{s=0;}{s+=$1;}END{print s;};')

cut -d "," -f7,8 flow.csv | awk 'BEGIN{FS=","};{end=$2; start=$1;print end-start};' | sort -n | uniq -c | awk 'BEGIN{X = 0;};{X+=$1;print X/ENVIRON["sum"],$2;};' > results.txt

#was sort -nr for last script

