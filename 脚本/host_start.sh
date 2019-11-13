#!/bin/bash
for i in {1..254}
do
  ping -c2 -i0.3 -w1 192.168.4.$i &>/dev/null
if [ $? -eq 0 ];then
   echo "192.168.4.$i is up
else
   echo "192.168.4.$i is down"
fi
done
