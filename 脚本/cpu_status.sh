#!/bin/bash
#对业务进程 CPU 进行实时监控
function GetCpu 
  { 
   CpuValue=`ps -p $1 -o pcpu |grep -v CPU | awk '{print $1}' | awk -  F. '{print $1}'` 
        echo $CpuValue 
    }
