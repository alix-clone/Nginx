#!/bin/bash
#通过条件语句判断 CPU 利用率是否超过限制，如果超过 80%（可以根据实际情况进行调整），则输出告警，否则输出正常信息
function CheckCpu 
 { 
    PID=$1 
    cpu=`GetCpu $PID` 
    if [ $cpu -gt 80 ] 
    then 
    { 
 echo “The usage of cpu is larger than 80%”
    } 
    else 
    { 
 echo “The usage of cpu is normal”
    } 
    fi 
 }
