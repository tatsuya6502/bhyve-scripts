#!/bin/sh

bhyvectl --destroy --vm=openbsd-dev
rm *.core

set e

grub-bhyve -m device.map -r hd0,openbsd1 -M 4096M openbsd-dev < ./grub.in > /dev/null

bhyve -W -c 4 -m 4096M -H -P -A -l com1,stdio \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,tap4 \
      -s 3,virtio-blk,/dev/zvol/zroot/bhyve/openbsd-dev/disk1 \
      openbsd-dev

bhyvectl --destroy --vm=openbsd-dev
