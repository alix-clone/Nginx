#!/bin/bash
#检查mysql主从从结构中从数据库服务器的状态
#1）本机的数据库服务是否正在运行
#2）能否与主数据库服务器正常通信
#3）能否使用授权用户连接数据库服务器
#4）本机的slave_IO进程是否处于YES状态
#   本机的slave_SQL进程是否处于YES状态

netstat -tulnp | grep :3306 > /dev/null
if [ $? -eq 0 ];then
echo "服务正在运行" 
else
service mysqld start
fi
ping -c 3 192.168.1.100 &> /dev/null
if [ $? -eq 0 ];then
echo "网络连接正常" 
else
echo "网络连接失败"
fi
mysql -h192.168.1.100 -uroot -p123456 &> /dev/null
if [ $? -eq 0 ];then
echo "数据库连接成功" 
else
echo "数据库连接失败"
fi
IO= mysql -uroot -p123 -e "show slave status\G" | grep Slave_IO_Running | awk '{print $2}' > /dev/null
SQL= mysql -uroot -p123 -e "show slave status\G" | grep Slave_SQL_Running | awk '{print $2}' /dev/null
if [ IO==Yes ] && [ SQL==Yes ];then
echo “IO and SQL 连接成功”
else
echo "IO线程和SQL线程连接失败"
fi
