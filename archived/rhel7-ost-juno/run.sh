#!/bin/sh

bhyvectl --destroy --vm=rhel7-ost-juno
rm *.core

set -e

grub-bhyve -m device.map -r hd0,msdos1 -M 4096M rhel7-ost-juno < ./grub.in > /dev/null

bhyve -c 4 -m 4096M -H -P -A -l com1,stdio \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,tap2 \
      -s 3,virtio-blk,/dev/zvol/zroot0/bhyve/rhel7-ost-juno/disk1 \
      rhel7-ost-juno

bhyvectl --destroy --vm=rhel7-ost-juno
