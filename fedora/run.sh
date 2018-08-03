#!/bin/sh

VM_NAME=fedora
NUM_CPUS=2
RAM_SIZE=4096M
# RAM_SIZE=8192M
TAP_DEV=tap3
DISK1=/dev/zvol/zdata77/bhyve/fedora/disk1
DISK2=/dev/zvol/zdata77/bhyve/fedora/disk2

bhyvectl --destroy --vm=$VM_NAME
rm *.core

set -e

bhyve -c $NUM_CPUS -m $RAM_SIZE -H -P -A \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,$TAP_DEV \
      -s 3,virtio-blk,$DISK1 \
      -s 4,virtio-blk,$DISK2 \
      -s 29,fbuf,tcp=0.0.0.0:5900,w=1920,h=1080 \
      -s 30,xhci,tablet \
      -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
      $VM_NAME

bhyvectl --destroy --vm=$VM_NAME
