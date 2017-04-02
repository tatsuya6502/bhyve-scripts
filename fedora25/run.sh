#!/bin/sh

VM_NAME=fedora25
RAM_SIZE=4096M
TAP_DEV=tap3

bhyvectl --destroy --vm=$VM_NAME
rm *.core

set e

bhyve -c 4 -m $RAM_SIZE -H -P -A \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,$TAP_DEV \
      -s 3,virtio-blk,/dev/zvol/zroot/bhyve/fedora25/disk1 \
      -s 29,fbuf,tcp=0.0.0.0:5900,w=1920,h=1080 \
      -s 30,xhci,tablet \
      -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
      $VM_NAME

bhyvectl --destroy --vm=$VM_NAME
