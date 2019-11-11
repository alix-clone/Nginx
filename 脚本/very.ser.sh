#!/bin/bash
#只检查服务vsftpd httpd sshd crond、mysql中任意一个服务的状态,如果服务是运行着的就输出 "服务名 is running",如果服务没有运行就启动服务
if [ -z $1 ];then
echo "You mast specify a servername!"
echo "Usage: `basename$0` servername"
exit 2
fi
if [ $1 == "crond" ] || [ $1 == "mysql" ] || [ $1 == "sshd" ] || [ $1 == "httpd" ] || [ $1 == "vsftpd" ];then
service $1 status &> /dev/null
if [ $? -eq 0 ];then
echo "$1 is running"
else
service $1 start
fi
else
echo "Usage:`basename $0` server name"
echo "But only check for vsftpd httpd sshd crond mysqld" && exit 2
fi
