#!/bin/sh

VM_NAME=centos7-docker1
NUM_CPUS=4
# RAM_SIZE=8G
RAM_SIZE=22G
TAP_DEV=tap1
VNC_PORT=5901

DISK1=/dev/zvol/zdata77/bhyve/cent7d1/disk1
DISK2=/dev/zvol/zroot/bhyve/cent7d1/disk2
CD=/home/tatsuya/installers/centos7/CentOS-7-x86_64-Minimal-1804.iso

run_vm_with_installer_cd()
{
    bhyve -c $NUM_CPUS -m $RAM_SIZE -H -P -A \
        -s 0:0,hostbridge \
        -s 2:0,virtio-net,$TAP_DEV \
        -s 3,ahci-cd,$CD \
        -s 4,virtio-blk,$DISK1 \
        -s 29,fbuf,tcp=0.0.0.0:$VNC_PORT,w=1280,h=720 \
        -s 30,xhci,tablet \
        -s 31,lpc -l com1,stdio \
        -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
        $VM_NAME
}

run_vm()
{
    bhyve -c $NUM_CPUS -m $RAM_SIZE -H -P -A \
        -s 0:0,hostbridge \
        -s 2:0,virtio-net,$TAP_DEV \
        -s 3,virtio-blk,$DISK1 \
        -s 4,virtio-blk,$DISK2 \
        -s 29,fbuf,tcp=0.0.0.0:$VNC_PORT,w=1280,h=720 \
        -s 30,xhci,tablet \
        -s 31,lpc -l com1,stdio \
        -l bootrom,/usr/local/share/uefi-firmware/BHYVE_UEFI.fd \
        $VM_NAME
}

destroy_vm()
{
    bhyvectl --destroy --vm=$VM_NAME
}


rm -f *.core

if [ "x$1" = "xinstall" ]; then
    destroy_vm
    set -e
    run_vm_with_installer_cd
    destroy_vm

elif [ "x$1" = "xrun" ]; then
    destroy_vm
    set -e
    run_vm
    destroy_vm

else
    echo 'Please type "install" or "run".'
    exit 8
fi
