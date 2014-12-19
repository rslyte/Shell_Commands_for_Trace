#!/bin/bash

#Get both the total packets and total bytes from the trace and store to enivronment vars
export packets=$(tail -n +2 flow.csv | cut -d "," -f5 | awk 'BEGIN{total=0;};{total+=$1;}END{print total;};')
export bytes=$(tail -n +2 flow.csv | cut -d "," -f5,6 | awk 'BEGIN{FS=",";total=0;};{total+=$1*$2;}END{print total;};')

#calculate WSU prefix: (134*2^24+121*2^16)/(2^16) = 34425
#then go through in both these scripts and sum up the packets and bytes from all occurrences that have 34425
tail -n +2 flow.csv | cut -d "," -f5,11,21 --output-delimiter="." | awk 'BEGIN{FS=".";};{sum=$2*(2^24)+$3*(2^16)+$4*(2^8)+$5;prefix = sum / 2^(32-$6);prefix = int(prefix);print prefix, $1;};' | sort -nr | awk 'BEGIN{total=0;};{if ($1=="34425")total+=$2;};END{printf("%.12f percent of packets in the trace are outgoing from WSU.\n", total/ENVIRON["packets"]);};'

tail -n +2 flow.csv | cut -d "," -f5,6,11,21 --output-delimiter="." | awk 'BEGIN{FS=".";};{sum=$3*(2^24)+$4*(2^16)+$5*(2^8)+$6;prefix = sum / 2^(32-$7);prefix = int(prefix);print prefix, $1*$2;};' | sort -nr | awk 'BEGIN{total=0;};{if ($1=="34425")total+=$2;};END{printf("%.12f percent of total bytes in the trace are outgoing from WSU.\n", total/ENVIRON["bytes"]);};'

#now do the same thing for occurrences coming *front* WSU except we use destination address and destination length instead of the source ones
tail -n +2 flow.csv | cut -d "," -f5,12,22 --output-delimiter="." | awk 'BEGIN{FS=".";};{sum=$2*(2^24)+$3*(2^16)+$4*(2^8)+$5;prefix = sum / 2^(32-$6);prefix = int(prefix);print prefix, $1;};' | sort -nr | awk 'BEGIN{total=0;};{if ($1=="34425")total+=$2;};END{printf("%.12f percent of packets in the trace are incoming from WSU.\n", total/ENVIRON["packets"]);};'

tail -n +2 flow.csv | cut -d "," -f5,6,12,22 --output-delimiter="." | awk 'BEGIN{FS=".";};{sum=$3*(2^24)+$4*(2^16)+$5*(2^8)+$6;prefix = sum / 2^(32-$7);prefix = int(prefix);print prefix, $1*$2;};' | sort -nr | awk 'BEGIN{total=0;};{if ($1=="34425")total+=$2;};END{printf("%.12f percent of total bytes in the trace are incoming from WSU.\n", total/ENVIRON["bytes"]);};' 
