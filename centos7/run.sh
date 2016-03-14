#!/bin/sh

bhyvectl --destroy --vm=centos7-docker1
rm *.core

set e

grub-bhyve -m device.map -r hd0,msdos1 -M 4096M centos7-docker1 < ./grub.in > /dev/null

bhyve -c 4 -m 4096M -H -P -A -l com1,stdio \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,tap0 \
      -s 3,virtio-blk,/dev/zvol/zroot/bhyve/centos7-docker/disk1 \
      centos7-docker1

bhyvectl --destroy --vm=centos7-docker1
