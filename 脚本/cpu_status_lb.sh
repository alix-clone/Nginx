#!/bin/bash
#检测系统 CPU 负载
function GetSysCPU 
 { 
   CpuIdle=`vmstat 1 5 |sed -n '3,$p' \n
   |awk '{x = x + $15} END {print x/5}' |awk -F. '{print $1}'
   CpuNum=`echo "100-$CpuIdle" | bc` 
   echo $CpuNum 
 }
