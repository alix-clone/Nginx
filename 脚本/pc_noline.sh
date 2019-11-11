#!/bin/bash
#输出192.168.4.0/24网段内在线主机的ip地址,统计不在线主机的台数，并把不在线主机的ip地址和不在线时的时间保存到/tmp/ip.txt文件里
ip=192.168.4.
j=0
for i in `seq 10 12`
do
ping -c 3 $ip$i &> /dev/null
if [ $? -eq 0 ];then
echo 在线的主机有：$ip$i
else
let j++
echo $ip$i >> /tmp/ip.txt
date >> /tmp/ip.txt
fi
done
echo 不在线的主机台数有 $j
