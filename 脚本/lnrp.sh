#!/bin/bash
yum -y install gcc pcre-devel openssl-devel
cd lnmp
useradd -s /sbin/nologin nginx
tar -xf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure --user=nginx --group=nginx --with-stream --with-http_ssl_module --with-http_stub_status_module
make && make install
yum -y install php php-fpm php-devel
sed -i '65,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '/SCRIPT_FILENAME/d' /usr/local/nginx/conf/nginx.conf
sed -i 's/fastcgi_params/fastcgi.conf/' /usr/local/nginx/conf/nginx.conf
systemctl restart php-fpm
systemctl enable php-fpm
/usr/local/nginx/sbin/nginx
tar -zxvf php-redis-2.2.4.tar.gz
phpize
./configure --with-php-config=/usr/bin/php-config
make && make install
