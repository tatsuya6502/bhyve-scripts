#!/bin/sh

VM_NAME=ubuntu1604-docker2
RAM_SIZE=10240M
TAP_DEV=tap2

bhyvectl --destroy --vm=$VM_NAME
rm *.core

set e

grub-bhyve -m device.map -r hd0,msdos1 -M $RAM_SIZE $VM_NAME

bhyve -c 4 -m $RAM_SIZE -H -P -A -l com1,stdio \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,$TAP_DEV \
      -s 3,virtio-blk,/dev/zvol/zroot/bhyve/ub1604d2/disk1 \
      -s 4,virtio-blk,/dev/zvol/zroot/bhyve/ub1604d2/disk2 \
      $VM_NAME

bhyvectl --destroy --vm=$VM_NAME
