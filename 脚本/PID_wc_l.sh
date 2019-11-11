#!/bin/bash
#查看某个进程名正在运行的个数
Runnum=`ps -ef | grep -v vi | grep -v tail | grep "[ /]CFTestApp" | grep -v grep | wc -l
