#!/bin/sh

bhyvectl --destroy --vm=centos6-hibari2
rm *.core

set e

grub-bhyve -m device.map -r hd0,msdos1 -M 4096M centos6-hibari2 < ./grub.in > /dev/null

bhyve -c 4 -m 4096M -H -P -A -l com1,stdio \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,tap2 \
      -s 3,virtio-blk,/dev/zvol/zroot/bhyve/centos6-hyperstore-hibari2-2016-05-01/disk1 \
      centos6-hibari2

bhyvectl --destroy --vm=centos6-hibari2
