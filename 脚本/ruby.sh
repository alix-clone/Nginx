#!/bin/bash
#部署ruby脚本运行环境,创建管理集群脚本:redis-trib
yum -y install rubygems
gem install redis-3.2.1.gem
rpm -q ruby || yum -y install ruby
mkdir /root/bin
tar -zxvf redis-4.0.8.tar.gz
cd redis-4.0.8/src/
cp redis-trib.rb /root/bin/
chmod +x /root/bin/redis-trib.rb
