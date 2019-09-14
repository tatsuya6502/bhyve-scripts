#!/bin/sh

VM_NAME=rhel7-ost-pike
RAM_SIZE=6144M
# RAM_SIZE=4096M
TAP_DEV=tap10
VNC_PORT=5903

# 1. OpenStack Pike installed (clean)
# DISK1=/dev/zvol/zssd/bhyve/rh-ost-pike/disk1

# 2. OpenStack Pike and connector development
# DISK1=/dev/zvol/zssd/bhyve/rh-ost-pike/disk1b

# 3. For GA test (clone of #1)
DISK1=/dev/zvol/zssd/bhyve/rh-ost-pike/disk1-gatst

# Old Disk1
# DISK1=/dev/zvol/zroot/bhyve/rh-ost-pike/disk1
# DISK1=/dev/zvol/zroot/bhyve/rh-ost-pike/disk1c

# Other Disks
DISK2=/dev/zvol/zroot/bhyve/rh-ost-pike/disk2
INSTALL_DVD=/home/tatsuya/installers/rhel-7.4/rhel-server-7.4-x86_64-dvd.iso

bhyvectl --destroy --vm=$VM_NAME
rm *.core

set e

# Booting from live DVD, with fbuf
# ---------------------------------------------
# bhyve -c 4 -m $RAM_SIZE -H -P -A -u \
#       -s 0:0,hostbridge \
#       -s 1:0,lpc \
#       -s 2:0,virtio-net,$TAP_DEV \
#       -s 3,ahci-cd,$INSTALL_DVD \
#       -s 4,virtio-blk,$DISK1 \
#       -s 5,virtio-blk,$DISK2 \
#       -s 29,fbuf,tcp=0.0.0.0:$VNC_PORT,w=1280,h=800 \
#       -s 30,xhci,tablet \
#       -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
#       $VM_NAME

# Booting from hard drive, with fbuf
# ---------------------------------------------
bhyve -c 4 -m $RAM_SIZE -H -P -A -u \
      -s 0:0,hostbridge \
      -s 1:0,lpc \
      -s 2:0,virtio-net,$TAP_DEV \
      -s 3,virtio-blk,$DISK1 \
      -s 4,virtio-blk,$DISK2 \
      -s 29,fbuf,tcp=0.0.0.0:$VNC_PORT,w=1280,h=800 \
      -s 30,xhci,tablet \
      -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
      $VM_NAME

bhyvectl --destroy --vm=$VM_NAME
