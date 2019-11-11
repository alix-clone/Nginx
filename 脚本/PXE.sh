#!/bin/bash
#安装BIND包，即DNS服务

yum -y install bind bind-chroot


#生成BIND  key

rndc-confgen -r /dev/urandom -a


#查看状态

#rndc status

#cat /etc/rndc.key

#ls -l /etc/rndc.key


#属主、属组，或者说是权限调整

chown named:named /etc/rndc.key

chmod 644 /etc/rndc.key


#rndc status

#/etc/init.d/named start


#修改主配置文件，RHEL6之后BIND配置与RHEL5有较大不同

sed -i 's/127.0.0.1/any/g' /etc/named.conf


#备份原区域配置文件

mv /etc/named.rfc1912.zones /etc/named.rfc1912.zones.bak


#编写区域配置文件

echo 'zone "pxe.com" IN {

        type master;

        file "pxe.zone";

};


zone "90.168.192.in-addr.arpa" IN {

        type master;

        file "90.168.192.zone";

};' > /etc/named.rfc1912.zones


#主、区域配置文件的属主、属组，即权限

cd /etc

chown named:named named.conf named.rfc1912.zones


#编写区域文件库

#正向解析文件，111.111.111.111是测试地址，测试时注意修改/etc/resolv.conf

echo '$TTL 3600

@       IN      SOA     @       root.pxe.com.(

                        2014062500

                        28800

                        14400

                        17200

                        86400)

        NS      @

        A       127.0.0.1

www     A       111.111.111.111

$GENERATE       100-200 pc$     IN      A       172.16.90.$' > /var/named/pxe.zone


#反向解析文件

#这里的@表示：90.168.192.in-addr.arpa  。与RHEL5有较大不同，注意。

echo '$TTL 3600

@       IN      SOA     @       root.pxe.com.(

                2014062500

                28800

                14400

                17200

                86400)

        NS      @

        A       127.0.0.1

199     PTR     www.pxe.com.

$GENERATE       100-200 $       IN      PTR     pc$.pxe.com.' > /var/named/90.168.192.zone


#修改属主、属组

cd /var/named

chown named:named pxe.zone 90.168.192.zone


#安装DHCP服务，这里我自己定义了网卡信息，可以根据实际情况进行修改

#修改时要和BIND文件里相对应，否则会出错，网卡也可以自己定义

echo '请保证服务器有一个静态的IP地址'

read -p '键入yes系统将自动配置IP相关信息，键入no退出：' flag

if [ $flag == 'yes' or 'y' ];then

    echo 'continue'

else

    if [ $flag == 'no' or 'n' ];then

        exit

    fi

fi


yum -y install dhcp

sed -ri 's/^IPADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth1

sed -ri 's/^NETMASK/d' /etc/sysconfig/network-scripts/ifcfg-eth1

sed -ri 's/^GATEWAY/d' /etc/sysconfig/network-scripts/ifcfg-eth1

sed -ri 's/^DNS/d' /etc/sysconfig/network-scripts/ifcfg-eth1


echo 'IPADDR=172.16.90.222

NETMASK=255.255.255.0

GATEWAY=172.16.90.1' >> /etc/sysconfig/network-scripts/ifcfg-eth1


sed -ri 's/(ONBOOT=)(no)/\1yes/g' /etc/sysconfig/network-scripts/ifcfg-eth1

sed -ri 's/(NM_CONTROLLED=)(yes)/\1no/g' /etc/sysconfig/network-scripts/ifcfg-eth1

sed -ri 's/(BOOTPROTO=)(.*)/\1static/g' /etc/sysconfig/network-scripts/ifcfg-eth1


#next-server指TFTP服务地址，一般就是本机（PXE服务器）

#pxelinux.0网卡引导文件

#修改网段信息时，注意和BIND文件中的地址及反向区域解析文件名保持一致

echo 'ddns-update-style interim;

ignore client-updates;

subnet 172.16.90.0 netmask 255.255.255.0 {

        option routers 172.16.90.1;

        option subnet-mask 255.255.255.0;

        option domain-name "pxe.com";

        option domain-name-servers 172.16.90.1;

        option time-offset -18000;

        range dynamic-bootp 172.16.90.100 172.16.90.200;

        default-lease-time 21600;

        max-lease-time 43200;

        next-server 172.16.90.222;

        filename "pxelinux.0";

}' > /etc/dhcp/dhcpd.conf


#安装TFTP服务

yum -y install tftp-server

yum -y install syslinux


mkdir -p /tftpboot/pxelinux.cfg


#这里一定要把要安装系统的ISO镜像文件挂载上，否则无法安装

umount /dev/cdrom

mount /dev/cdrom /media


#拷贝系统内核

cp /media/isolinux/vmlinuz /tftpboot

#拷贝内核镜像

cp /media/isolinux/initrd.img /tftpboot

#拷贝网卡引导文件

cp /usr/share/syslinux/pxelinux.0 /tftpboot


#修改TFTP配置文件，更改根目录以及打开xinetd.d服务托管

sed -ri '13s#(.*)(=)( )(.*)#\1\2\3-s /tftpboot#g' /etc/xinetd.d/tftp

sed -ri '14s/(.*)(=)( )yes/\1\2\3no/g' /etc/xinetd.d/tftp


#编写引导操作系统的Default文件

#改文件也可以从ISO里拷贝cp /media/isolinux/isolinux.cfg /tftpboot/pxelinux.cfg/default，然后修改一下即可，这里我根据拷贝的文件自己写了一个default文件，方便脚本执行

#ksdevice=eth0，如果要安装系统的服务器上有多网卡的话，在这里指定即可，后面无人值守安装时就不会出现选择网卡的信息

#ks=nfs:172.16.90.222:/ks/ks.cfg，这是kickstart文件的路径，后续有具体配置


echo 'default linux6

prompt 1

timeout 600


display boot.msg


menu background splash.jpg

menu title Welcome to Red Hat Enterprise Linux 6.4!

menu color border 0 #ffffffff #00000000

menu color sel 7 #ffffffff #ff000000

menu color title 0 #ffffffff #00000000

menu color tabmsg 0 #ffffffff #00000000

menu color unsel 0 #ffffffff #00000000

menu color hotsel 0 #ff000000 #ffffffff

menu color hotkey 7 #ffffffff #ff000000

menu color scrollbar 0 #ffffffff #00000000


label linux6

  menu label ^Install or upgrade an existing system

  menu default

  kernel vmlinuz

  append initrd=initrd.img ksdevice=eth0 ks=nfs:172.16.90.222:/ks/ks.cfg

label vesa

  menu label Install system with ^basic video driver

  kernel vmlinuz

  append initrd=initrd.img xdriver=vesa nomodeset

label rescue

  menu label ^Rescue installed system

  kernel vmlinuz

  append initrd=initrd.img rescue

label local

  menu label Boot from ^local drive

  localboot 0xffff

label memtest86

  menu label ^Memory test

  kernel memtest

  append -' > /tftpboot/pxelinux.cfg/default


#安装NFS包

yum -y install nfs-utils

mkdir -p /ks


#添加共享文件

echo '/ks    *(ro)' > /etc/exports

echo '/media *(ro)' >> /etc/exports

echo '/tftpboot *(ro)' >> /etc/exports


#生成自应答文件

echo '##########################################################

#-------------------ks.cfg的权限给777--------------------#

#--安装不同版本系统时，可对比其/root/anaconda-ks.cfg文件-#

##########################################################


# Kickstart file automatically generated by anaconda.

#version=DEVEL


install

#告诉系统来安装全新的系统而不是在现有系统上升级.这是缺省的模式.必须指定安装的类型,如cdrom,harddrive,nfs或url(FTP 或HTTP安装).install命令和安装方法命令必须处于不同的行上.


nfs --server=172.16.90.222 --dir=/media

#指定安装路径 --server:PXE服务器地址  --dir:光盘挂载路径


#cdrom

#从系统上的第一个光盘驱动器中安装


lang zh_CN.UTF-8

#设置在安装过程中使用的语言以及系统的缺省语言


keyboard us

#设置系统键盘类型


network --onboot no --device eth0 --bootproto dhcp --noipv6

#network --onboot no --device eth1 --bootproto dhcp --noipv6

#为系统配置网络信息


rootpw  --iscrypted $6$8BEv0.LPITKkIQp9$eoNGB63kZocA83zRVZxtZdt8QWOdifMJEUDUbJZ490KyKE0nhc6g.zQWXnc25cbIhfeoiRy6lXBDe4oSZ5B440

#把系统的根口令设置为<password>参数. 我这里密码为111111

#rootpw [--iscrypted] <password>   --iscrypted,如果该选项存在,口令就会假定已被加密.


firewall --service=ssh

#这个选项对应安装程序里的「防火墙配置」屏幕:


authconfig --enableshadow --passalgo=sha512

#为系统设置验证选项.在缺省情况下,密码通常被加密但不使用影子文件(shadowed).


selinux --disable

#在系统里设置SELinux状态


timezone --utc Asia/Shanghai

#设置系统时区


zerombr yes

#如果指定了zerombr（yes是它的唯一参数）,任何磁盘上的无效分区表都将被初始化.这会毁坏有无效分区表的磁盘上的所有内容.

#没有这一步，安装时会提示选择数据存储的问题


#bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"

bootloader --location=mbr --driveorder=sda --append="auto rhgb quiet"

#指定引导装载程序怎样被安装.对于安装和升级,这个选项都是必需的.


clearpart --drives=sda --initlabel

#clearpart --all    #删除系统上所有分区.

#--drives=,指定从哪个驱动器上清除分区.

#在创建新分区之前,从系统上删除分区.默认不会删除任何分区.


part /boot --fstype ext4 --size=200 --ondrive=sda

part swap --size=2048  --ondrive=sda

part / --fstype ext4 --grow --size=10240  --ondrive=sda

#创建分区，--size=,以MB为单位的分区最小值.

#--grow,告诉分区使用所有可用空间(若有),或使用设置的最大值.

#这里根据实际情况进行更改



# The following is the partition information you requested

# Note that any partitions you deleted are not expressed

# here so unless you clear all partitions first, this is

# not guaranteed to work

#clearpart --none


#part /boot --fstype=ext4 --size=200

#part swap --size=2048

#part / --fstype=ext4 --grow --size=200


#选择需要安装的软件包.

%packages

@base

@chinese-support

@core

@development

@hardware-monitoring

@server-policy

python-dmidecode

sgpio

device-mapper-persistent-data

%end


reboot' > /ks/ks.cfg


#调整权限

chmod 777 /ks/ks.cfg


#重启相关服务

/etc/init.d/iptables stop


/etc/init.d/named stop &> /dev/null

/etc/init.d/named start


/etc/init.d/network restart


/etc/init.d/dhcpd stop &> /dev/null

/etc/init.d/dhcpd start


/etc/init.d/xinetd stop &> /dev/null

/etc/init.d/xinetd start


/etc/init.d/rpcbind stop &> /dev/null

/etc/init.d/rpcbind start


/etc/init.d/nfs stop &> /dev/null

/etc/init.d/nfs start


#PXE服务安装完成，可以进行测试了
