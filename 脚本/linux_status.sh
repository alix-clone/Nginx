#!/bin/bash
export Start_Color="\e[1;32m"
export End_Color="\e[0m"
Ipaddr=`ifconfig | grep -Eo --color=auto "(\<([1-9]|[1-9][0-9]|[1-9][0
-9]{2}|2[0-4][0-9]|25[0-5])\>\.){3}\<([1-9]|[1-9][0-9]|[1-9][0-9]{2}|2
[0-4][0-9]|25[0-5])\>"| head -1`
Version=`cut -d" "  -f4 /etc/redhat-release`
KerneVer=`uname -r`
Cpu_Info=`lscpu | grep "Model name:"|tr -s " " |cut -d: -f2`
Mem_Info=`free -mh|tr -s " "|cut -d" " -f2 |head -2| tail -1`
HD_Info=`lsblk | grep "^sd\{1,\}"| tr -s " "|cut -d" " -f1,4`
echo -e "The System Hostname is : $Start_Color `hostname` $End_Color"
echo -e "The System IP ADDER is : $Start_Color $Ipaddr $End_Color"
echo -e "The System Version  is : $Start_Color $Version $End_Color"   
echo -e "The System kerneVer is : $Start_Color $KerneVer $End_Color"
echo -e "The System Cpu_Info is :$Start_Color $Cpu_Info $End_Color"
echo -e "The System Mem_Info is : $Start_Color $Mem_Info $End_Color"
echo -e "The System HD_Info  is : $Start_Color \n$HD_Info $End_Color"
#disk.sh
unset Start_Color
unset End_Color
unset Ipaddr
unset Version
unset KerneVer
unset Cpu_Info
unset Mem_Info
unset HD_Info
