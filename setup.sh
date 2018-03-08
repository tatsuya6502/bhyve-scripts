#!/bin/sh

kldload if_tap
kldload if_bridge
kldload vmm
kldload nmdm
sysctl net.link.tap.up_on_open=1
sysctl net.inet.ip.forwarding=1

# tap0: centos7-docker1
# tap1: centos6-hibari1
# tap2: centos6-hibari2
# tap3: rhel7-ost-kilo
# tap4: openbsd - global
# tap5: ubuntu1604-docker1
# tap6: openbsd - local
# tap7: rhel7-ost-mitaka
# tap8: rhel7-ost-newton
# tap9: rhel7-ost-ocata
# tap10: rhel7-ost-pike

ifconfig tap0 create
ifconfig tap1 create
ifconfig tap2 create
ifconfig tap3 create
ifconfig tap4 create
ifconfig tap5 create
ifconfig tap6 create
ifconfig tap7 create
ifconfig tap8 create
ifconfig tap9 create
ifconfig tap10 create

# DS57U5 has two NICs, em0 and igb0
# Global Bridge (OpenBSD)
ifconfig bridge0 create
ifconfig bridge0 addm em0 addm tap4 up

# Local Bridge (Others)
ifconfig bridge1 create
ifconfig bridge1 addm igb0 addm tap6 up
ifconfig bridge1 addm tap0
ifconfig bridge1 addm tap1
ifconfig bridge1 addm tap2
ifconfig bridge1 addm tap3
ifconfig bridge1 addm tap5
ifconfig bridge1 addm tap7
ifconfig bridge1 addm tap8
ifconfig bridge1 addm tap9
ifconfig bridge1 addm tap10
ifconfig bridge1 addm wlan0
