#!/bin/sh

VM_NAME=ubuntu1604-docker1
RAM_SIZE=4096M
TAP_DEV=tap5

bhyvectl --destroy --vm=$VM_NAME
rm *.core

set e

grub-bhyve -m device.map -r hd0,msdos1 -M $RAM_SIZE $VM_NAME

bhyve -c 4 -m $RAM_SIZE -H -P -A -l com1,stdio \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,$TAP_DEV \
      -s 3,virtio-blk,/dev/zvol/zroot/bhyve/ub1604d1/disk1 \
      -s 4,virtio-blk,/dev/zvol/zroot/bhyve/ub1604d1/disk2 \
      $VM_NAME

bhyvectl --destroy --vm=$VM_NAME
