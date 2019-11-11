#!/bin/bash
#检测进程句柄使用量,通过条件语句判断句柄使用是否超过限制，如果超过 900（可以根据实际情况进行调整）个，则输出告警，否则输出正常信息。
des=` GetDes $PID` 
 if [ $des -gt 900 ] 
 then 
 { 
     echo “The number of des is larger than 900”
 } 
 else 
 { 
    echo “The number of des is normal”
 } 
 fi

