#!/bin/bash

#clear array
unset var1[@]

#if [ -z $1 ]; then
#    echo "Must specify which bird"
#    exit 1
#fi
#if [ -z $2 ]; then
 #   echo "Must specify frequency in MHz"
  #  exit 1
#fi

#get command line arg for bird/freq
bird=M2
freq=137.900

#
#calculate best passes
for i in {00..23}
do
var1[10#$i]=$(predict -t ~/wxsat/weather.txt -p "${bird}" $(date -d "+$i hour" +%s) | awk '{ if($5>=5) print $0}' |sort -u | head -1)
done

#calculate start-end for each pass
for x in $(printf -- '%s\n' "${var1[@]}" | grep : | awk '{print $1,$3$4}' | cut -d : -f 1,2 | sort -uk 2 | awk '{print $1}')
do
recstart=$(predict -t ~/wxsat/weather.txt -p "${bird}" $x | awk '{ if($5>=10) print $0}' | head -1 | awk '{print $1}')
recend=$(predict -t ~/wxsat/weather.txt -p "${bird}" $x | awk '{ if($5>=10) print $0}' | tail -1 | awk '{print $1}')
rectime=$(awk "BEGIN {print $recend-$recstart}")
init=$(date -d "@$recstart" +%y%m%d%H%M)
#create at file
cat << EOF > ~/wxsat/${bird}.at
recdate=\$(date +%Y%m%d-%H%M)
mapdate=\$(date '+%d %m %Y %H:%M')
timeout $rectime /usr/local/bin/rtl_fm -f ${freq}M -s 120000 -g 40.2 -F 9 -A fast -E dc -p 62 ~/wxsat/recordings/${bird}-\$recdate.raw
#/usr/bin/sox -t raw -r 72000 -es -b16 -c1 -V1 ~/wxsat/recordings/${bird}-\$recdate.raw ~/wxsat/recordings/${bird}-\$recdate.wav rate 11025
#touch -r ~/wxsat/recordings/${bird}-\$recdate.raw ~/wxsat/recordings/${bird}-\$recdate.wav
EOF
#schedule at
at -f ~/wxsat/${bird}.at -t $init
done

#clear array
unset var1[@]
