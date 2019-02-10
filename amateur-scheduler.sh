#!/bin/bash

#clear array
unset var1[@]

if [ -z $1 ]; then
    echo "Must specify which bird"
    exit 1
fi
if [ -z $2 ]; then
    echo "Must specify frequency in MHz"
    exit 1
fi

#get command line arg for bird/freq
bird=$1
freq=$2

#calculate best passes
for i in {00..23}
do
var1[10#$i]=$(predict -t ~/wxsat/amateur.txt -p "${bird}" $(date -d "+$i hour" +%s) | awk '{ if($5>=10) print $0}' |sort -u | head -1)
done

#calculate start-end for each pass
for x in $(printf -- '%s\n' "${var1[@]}" | grep : | awk '{print $1,$3$4}' | cut -d : -f 1,2 | sort -uk 2 | awk '{print $1}')
do
recstart=$(predict -t ~/wxsat/amateur.txt -p "${bird}" $x | awk '{ if($5>=10) print $0}' | head -1 | awk '{print $1}')
recend=$(predict -t ~/wxsat/amateur.txt -p "${bird}" $x | awk '{ if($5>=10) print $0}' | tail -1 | awk '{print $1}')
rectime=$(awk "BEGIN {print $recend-$recstart}")
init=$(date -d "@$recstart" +%y%m%d%H%M)
#create at file
cat << EOF > ~/wxsat/${bird}.at
recdate=\$(date +%Y%m%d-%H%M)
mapdate=\$(date '+%d %m %Y %H:%M')
timeout $rectime /usr/local/bin/rtl_fm -d 0 -f ${freq}M -s 48000 -g 44 -p 1 -F 9 -A fast -E DC ~/wxsat/recordings/${bird}-\$recdate.raw
/usr/bin/sox -t raw -r 48000 -es -b16 -c1 -V1 ~/wxsat/recordings/${bird}-\$recdate.raw ~/wxsat/recordings/${bird}-\$recdate.wav rate 11025
touch -r ~/wxsat/recordings/${bird}-\$recdate.raw ~/wxsat/recordings/${bird}-\$recdate.wav
cp ~/wxsat/recordings/${bird}-\$recdate.wav /media/cloud/coop/
EOF
#schedule at
at -f ~/wxsat/${bird}.at -t $init
done

#clear array
unset var1[@]
