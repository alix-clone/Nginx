#!/bin/bash
yum -y install gcc pcre-devel openssl-devel
useradd -s /sbin/nologin nginx
cd lnmp_soft
tar -xf nginx-1.15.8.tar.gz
cd nginx-1.15.8
./configure --user=nginx --group=nginx --with-stream --with-http_ssl_module --with-http_stub_status_module
make && make install
yum -y install mariadb mariadb-server mariadb-devel
yum -y install php php-mysql php-fpm
sed -i '65,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '/SCRIPT_FILENAME/d' /usr/local/nginx/conf/nginx.conf
sed -i 's/fastcgi_params/fastcgi.conf/' /usr/local/nginx/conf/nginx.conf
systemctl restart mariadb
systemctl enable mariadb
systemctl restart php-fpm
systemctl enable php-fpm
/usr/local/nginx/sbin/nginx
