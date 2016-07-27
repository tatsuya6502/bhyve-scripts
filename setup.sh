#!/bin/sh

kldload if_tap
kldload if_bridge
kldload vmm
kldload nmdm
sysctl net.link.tap.up_on_open=1
sysctl net.inet.ip.forwarding=1

# tap0: centos6-hibari3
# tap1: ubuntu-14.04
# tap2: rhel7-ost-juno
# tap3: rhel7-ost-icehouse
# tap4: openbsd
# tap5: centos6-vertica
# tap6: rhel7-ost-liberty (external)
# tap7: rhel7-ost-liberty (internal)

ifconfig tap0 create
ifconfig tap1 create
ifconfig tap2 create
ifconfig tap3 create
ifconfig tap4 create
ifconfig tap5 create
ifconfig tap6 create
ifconfig tap7 create

ifconfig bridge0 create
ifconfig bridge0 addm bge0 up
ifconfig bridge0 addm tap0
ifconfig bridge0 addm tap1
ifconfig bridge0 addm tap2
ifconfig bridge0 addm tap3
ifconfig bridge0 addm tap4
ifconfig bridge0 addm tap5
ifconfig bridge0 addm tap6
ifconfig bridge0 addm tap7
