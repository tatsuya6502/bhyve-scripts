#!/bin/sh

bhyvectl --destroy --vm=openbsd
rm *.core

set e

grub-bhyve -m device.map -r hd0,openbsd1 -M 256M openbsd < ./grub.in > /dev/null

bhyve -W -c 2 -m 256M -H -P -A -l com1,stdio \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,tap4 \
      -s 3,virtio-blk,/dev/zvol/zroot/bhyve/openbsd/disk1 \
      -s 4:0,virtio-net,tap6 \
      openbsd

bhyvectl --destroy --vm=openbsd
