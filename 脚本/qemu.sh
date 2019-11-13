#!/bin/bash
cd /var/lib/libvirt/images/
qemu-img create -b .node_base.qcow2 -f qcow2 ${1}.img 50G
cd /etc/libvirt/qemu/
sed "s,node,${1}," node.xml > ${1}.xml
virsh define ${1}.xml
