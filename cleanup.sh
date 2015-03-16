#!/bin/sh

ifconfig bridge0 down
ifconfig tap0 down
ifconfig tap1 down
ifconfig tap2 down
ifconfig tap3 down

ifconfig bridge0 destroy
ifconfig tap0 destroy
ifconfig tap1 destroy
ifconfig tap2 destroy
ifconfig tap3 destroy

kldunload vmm
kldunload nmdm

