#!/bin/bash
#对业务进程内存使用量进行监控
function GetMem 
    { 
        MEMUsage=`ps -o vsz -p $1|grep -v VSZ` 
        (( MEMUsage /= 1000)) 
        echo $MEMUsage 
    }
