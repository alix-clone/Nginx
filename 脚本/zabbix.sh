#!/bin/bash
yum -y install gcc pcre-devel  openssl-devel
cd /root/Zabbix
tar -xf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --with-http_ssl_module
make && make install
yum -y install php php-mysql mariadb mariadb-devel mariadb-server
yum -y install  php-fpm-5.4.16-42.el7.x86_64.rpm
sed -i '45s/index /index index.php /' /usr/local/nginx/conf/nginx.conf
sed -i '65,68s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '70,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '70s/_params/\.conf/' /usr/local/nginx/conf/nginx.conf
systemctl start  mariadb
systemctl start  php-fpm
ln -s /usr/local/nginx/sbin/nginx /sbin/nginx
nginx
firewall-cmd --set-default-zone=trusted
setenforce 0
cd
yum -y install  net-snmp-devel curl-devel
yum -y install   libevent-devel-2.0.21-4.el7.x86_64.rpm
cd /root/Zabbix
./configure  --enable-server  --enable-proxy --enable-agent --with-mysql=/usr/bin/mysql_config  --with-net-snmp --with-libcurl
make && make install
mysql -h'localhost' -e  "create database zabbix character set utf8"
mysql -h'localhost' -e "grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix'"
cd /root/Zabbix/zabbix-3.4.4/database/mysql/
mysql -uzabbix -pzabbix zabbix < schema.sql
mysql -uzabbix -pzabbix zabbix < images.sql
mysql -uzabbix -pzabbix zabbix < data.sql
cd /root/Zabbix/zabbix-3.4.4/frontends/php/
cp -r * /usr/local/nginx/html/
chmod -R 777 /usr/local/nginx/html/*
sed -i '/# DBHost=localhost/a\DBHost=localhost' zabbix_server.conf
sed -i '/# DBPassword=/a\DBPassword=zabbix' zabbix_server.conf
useradd -s /sbin/nologin zabbix
zabbix-server
sed -i '/^Server=/a\Server=127.0.0.1,192.168.2.5' /usr/local/etc/zabbix_agentd.conf
sed -i '/^ServerActive=/a\ServerActive=127.0.0.1,192.168.2.5' /usr/local/etc/zabbix_agentd.conf
sed -i '/^Hostname=/a\Hostname=zabbix_server' /usr/local/etc/zabbix_agentd.conf
sed -i '/^LogFile=/a\LogFile=/tmp/zabbix_server.log' /usr/local/etc/zabbix_agentd.conf
sed -i '/^UnsafeUserParameters=/a\UnsafeUserParameters=1' /usr/local/etc/zabbix_agentd.conf
abbix_agentd
cd /root/Zabbix
yum -y install  php-gd php-xml
yum install php-bcmath-5.4.16-42.el7.x86_64.rpm
yum install php-mbstring-5.4.16-42.el7.x86_64.rpm
sed -i '/^;date.timezone/a\date.timezone =  Asia/Shanghai' /etc/php.ini
sed -i '/^;max_execution_time/a\max_execution_time = 300' /etc/php.ini
sed -i '/^;post_max_size/a\post_max_size =  32M' /etc/php.ini
sed -i '/^;max_input_time/a\max_input_time = 300' /etc/php.ini
sed -i '/^;memory_limit/a\memory_limit =  128M' /etc/php.ini
systemctl restart php-fpm
