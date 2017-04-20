#!/bin/sh

VM_NAME=rhel7-ost-mitaka
RAM_SIZE=4096M
TAP_DEV=tap7

bhyvectl --destroy --vm=$VM_NAME
rm *.core

set e

# Booting from live DVD, with fbuf
# ---------------------------------------------
# bhyve -c 4 -m $RAM_SIZE -H -P -A \
#       -s 0:0,hostbridge \
#       -s 1:0,lpc \
#       -s 2:0,virtio-net,$TAP_DEV \
#       -s 3,ahci-cd,/home/tatsuya/installers/rhel-7.3/rhel-server-7.3-x86_64-dvd.iso \
#       -s 4,virtio-blk,/dev/zvol/zroot/bhyve/rh-ost-mitaka/disk1 \
#       -s 29,fbuf,tcp=0.0.0.0:5900,w=1920,h=1080 \
#       -s 30,xhci,tablet \
#       -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
#       $VM_NAME

# Booting from hard drive
# ---------------------------------------------
bhyve -c 4 -m $RAM_SIZE -H -P -A \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,$TAP_DEV \
      -s 3,virtio-blk,/dev/zvol/zroot/bhyve/rh-ost-mitaka/disk1 \
      -s 29,fbuf,tcp=0.0.0.0:5900,w=1280,h=800 \
      -s 30,xhci,tablet \
      -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
      $VM_NAME

bhyvectl --destroy --vm=$VM_NAME
