#!/bin/bash

#calculates the total amount of bytes in the trace
export traffic=$(tail -n +2 flow.csv | awk 'BEGIN{sum=0;};{sum+=1;};END{print sum;};')

#calculates the total traffic of unique prefixes
export prefixes=$(tail -n +2 flow.csv | cut -d "," -f11,21 --output-delimiter="." | awk 'BEGIN{FS=".";};{sum=$1*(2^24)+$2*(2^16)+$3*(2^8)+$4;num = sum / 2^(32-$5);num = int(num);print num;};' | sort -nr | uniq -c | awk 'BEGIN{sum = 0;};{sum+=1;};END{print sum;};')

#calculates top 10%, 1%, and .1% of src prefixes
export calc1=$(($prefixes/10)) #top 10%
export calc2=$(($prefixes/100)) #1%
export calc3=$(($prefixes/1000)) #.1%

#do final 10% calculations and print
tail -n +2 flow.csv | cut -d "," -f11,21 --output-delimiter="." | awk 'BEGIN{FS=".";};{sum=$1*(2^24)+$2*(2^16)+$3*(2^8)+$4;num = sum / 2^(32-$5);num = int(num);print num;};' | sort -nr | uniq -c | sort -nr | awk 'BEGIN{count=ENVIRON["calc1"]; percent=0;};{if(count == 0)exit;percent+=$1;count-=1;}END{printf("%.8f of total traffic comes from top 10 percent of prefixes.\n", percent/ENVIRON["traffic"]);};'

#do final 1% calculations and print
tail -n +2 flow.csv | cut -d "," -f11,21 --output-delimiter="." | awk 'BEGIN{FS=".";};{sum=$1*(2^24)+$2*(2^16)+$3*(2^8)+$4;num = sum / 2^(32-$5);num = int(num);print num;};' | sort -nr | uniq -c | sort -nr | awk 'BEGIN{count=ENVIRON["calc2"]; percent=0;};{if(count == 0)exit;percent+=$1;count-=1;}END{printf("%.8f of total traffic comes from top 1 percent of prefixes.\n", percent/ENVIRON["traffic"]);};'

#do final 0.1% calculaations and print
tail -n +2 flow.csv | cut -d "," -f11,21 --output-delimiter="." | awk 'BEGIN{FS=".";};{sum=$1*(2^24)+$2*(2^16)+$3*(2^8)+$4;num = sum / 2^(32-$5);num = int(num);print num;};' | sort -nr | uniq -c | sort -nr | awk 'BEGIN{count=ENVIRON["calc3"]; percent=0;};{if(count == 0)exit;percent+=$1;count-=1;}END{printf("%.8f of total traffic comes from top 0.1 percent of prefixes.\n", percent/ENVIRON["traffic"]);};'





