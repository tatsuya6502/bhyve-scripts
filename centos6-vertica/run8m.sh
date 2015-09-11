#!/bin/sh

bhyvectl --destroy --vm=centos6-vertica
rm *.core

set e

grub-bhyve -m device.map -r hd0,msdos1 -M 8192M centos6-vertica < ./grub.in > /dev/null

bhyve -c 4 -m 8192M -H -P -A -l com1,stdio \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,tap5 \
      -s 3,virtio-blk,/dev/zvol/zroot0/bhyve/centos6-vertica/disk1 \
      centos6-vertica

bhyvectl --destroy --vm=centos6-vertica
