#!/bin/bash
#端口检测,TCP 与 UDP 端口监听都为 0，返回 0，否则返回 1.
function Listening 
 { 
    TCPListeningnum=`netstat -an | grep ":$1 " | \n
    awk '$1 == "tcp" && $NF == "LISTEN" {print $0}' | wc -l` 
    UDPListeningnum=`netstat -an|grep ":$1 " \n
    |awk '$1 == "udp" && $NF == "0.0.0.0:*" {print $0}' | wc -l` 
    (( Listeningnum = TCPListeningnum + UDPListeningnum )) 
    if [ $Listeningnum == 0 ] 
    then 
    { 
        echo "0"
    } 
    else 
    { 
       echo "1"
    } 
    fi 
 }
