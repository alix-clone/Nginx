#!/bin/bash
#检测当前系统磁盘空间中某个目录的磁盘空间使用情况 . 输入参数为需要检测的目录名
function GetDiskSpc 
 { 
    if [ $# -ne 1 ] 
    then 
        return 1 
    fi 

    Folder="$1$"
    DiskSpace=`df -k |grep $Folder |awk '{print $5}' |awk -F% '{print $1}'
    echo $DiskSpace 
 }
