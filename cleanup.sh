#!/bin/sh

ifconfig bridge0 down
ifconfig tap0 down
ifconfig tap1 down
ifconfig tap2 down
ifconfig tap3 down
ifconfig tap4 down
ifconfig tap5 down
ifconfig tap6 down
ifconfig tap7 down

ifconfig bridge0 destroy
ifconfig tap0 destroy
ifconfig tap1 destroy
ifconfig tap2 destroy
ifconfig tap3 destroy
ifconfig tap4 destroy
ifconfig tap5 destroy
ifconfig tap6 destroy
ifconfig tap7 destroy

kldunload vmm
kldunload nmdm
