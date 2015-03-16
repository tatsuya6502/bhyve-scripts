#!/bin/sh

kldload if_tap
kldload if_bridge
kldload vmm
kldload nmdm
sysctl net.link.tap.up_on_open=1
sysctl net.inet.ip.forwarding=1

ifconfig tap0 create
ifconfig tap1 create
ifconfig tap2 create
ifconfig tap3 create

ifconfig bridge0 create
ifconfig bridge0 addm tap0 addm bge0 up
ifconfig bridge0 addm tap1
ifconfig bridge0 addm tap2
ifconfig bridge0 addm tap3

