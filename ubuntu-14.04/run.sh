#!/bin/sh

bhyvectl --destroy --vm=ubuntu-14.04
rm *.core

set e

grub-bhyve -m device.map -r hd0,msdos1 -M 2048M ubuntu-14.04 < ./grub.in > /dev/null

bhyve -c 4 -m 2048M -H -P -A -l com1,stdio \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,tap1 \
      -s 3,virtio-blk,/dev/zvol/zroot0/bhyve/ubuntu-14.04/disk1 \
      ubuntu-14.04

bhyvectl --destroy --vm=ubuntu-14.04

