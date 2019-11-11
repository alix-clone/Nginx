#!/bin/bash
#根据访问lastb,禁止10次以上ip访问
LOG=cat /data/script36/ss.log | sed -nr '/^ESTAB/s@.* ([0-9.]+):[0-9]+.* ([0-9.]+):[0-9]+.*$@\2@p'| sort | uniq -c
cat $LOG | while read num ip;do
    if [ $num -gt 10 ];then
        iptables -A INPUT -s $ip -j REJECT
    fi
done
