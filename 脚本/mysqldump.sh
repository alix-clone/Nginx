#!/bin/sh  
#auto backup mysql  
#wugk  2012-07-14  
#PATH DEFINE  
 
BAKDIR=/data/backup/mysql/`date +%Y-%m-%d`  
MYSQLDB=www  
MYSQLPW=backup  
MYSQLUSR=backup  
 
if[ $UID -ne 0 ];then  
echo This script must use administrator or root user ,please exit!  
sleep 2  
exit 0  
fi  
 
if[ ! -d $BAKDIR ];then  
mkdir -p $BAKDIR  
else  
echo This is $BAKDIR exists ,please exit ….  
sleep 2  
exit  
fi  
 
###mysqldump backup mysql  
 
/usr/bin/mysqldump -u$MYSQLUSR -p$MYSQLPW -d $MYSQLDB >/data/backup/mysql/`date +%Y-%m-%d`/www_db.sql  
 
cd $BAKDIR ; tar -czf  www_mysql_db.tar.gz *.sql  
 
cd $BAKDIR ;find  . -name “*.sql” |xargs rm -rf[ $? -eq 0 ]&&echo “This `date +%Y-%m-%d` RESIN BACKUP is SUCCESS”  
 
cd /data/backup/mysql/ ;find . -mtime +30 |xargs rm -rf
