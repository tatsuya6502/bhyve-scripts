#!/bin/sh

kldload if_tap
kldload if_bridge
kldload vmm
kldload nmdm
sysctl net.link.tap.up_on_open=1
sysctl net.inet.ip.forwarding=1

# tap0: centos6-hibari3
# tap1: centos7-docker2
# tap2: ubuntu1604-docker2
# tap3:
# tap4: openbsd-dev
# tap5:
# tap6:
# tap7:

ifconfig tap0 create
ifconfig tap1 create
ifconfig tap2 create
ifconfig tap3 create
ifconfig tap4 create
# ifconfig tap5 create
# ifconfig tap6 create
# ifconfig tap7 create

ifconfig bridge0 create
ifconfig bridge0 addm bge0 up
ifconfig bridge0 addm tap0
ifconfig bridge0 addm tap1
ifconfig bridge0 addm tap2
ifconfig bridge0 addm tap3
ifconfig bridge0 addm tap4
# ifconfig bridge0 addm tap5
# ifconfig bridge0 addm tap6
# ifconfig bridge0 addm tap7
