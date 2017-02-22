#!/bin/sh

## Setup script for a WiFi-based network (wlan0)

kldload if_tap
kldload if_bridge
kldload vmm
kldload nmdm
sysctl net.link.tap.up_on_open=1
sysctl net.inet.ip.forwarding=1

# You also need to run pf to provide NAT from tap devices to wlan0
#
# /etc/rc.conf
# --------------------------
# pf_enable="YES"
# pf_flags=""
# pf_rules="/etc/pf.conf"
# pflog_enable="yes"
# gateway_enable="YES"
# --------------------------
#
# /etc/pf.conf
# --------------------------
# ext_if="wlan0"
#
# # Maybe I should use a table?
# bhyve_net="172.25.0.0/16"
# bhyve_tap0="172.25.0.10"
# bhyve_tap1="172.25.0.11"
# bhyve_tap2="172.25.0.12"
# bhyve_tap3="172.25.0.13"
# bhyve_tap4="172.25.0.14"
# bhyve_tap5="172.25.0.15"
# bhyve_tap6="172.25.0.16"
# bhyve_tap7="172.25.0.17"
#
# set block-policy return
# set skip on lo
# scrub in
#
# nat pass on $ext_if from $bhyve_tap0 to !$bhyve_net -> $ext_if
# nat pass on $ext_if from $bhyve_tap1 to !$bhyve_net -> $ext_if
# nat pass on $ext_if from $bhyve_tap2 to !$bhyve_net -> $ext_if
# nat pass on $ext_if from $bhyve_tap3 to !$bhyve_net -> $ext_if
# nat pass on $ext_if from $bhyve_tap4 to !$bhyve_net -> $ext_if
# nat pass on $ext_if from $bhyve_tap5 to !$bhyve_net -> $ext_if
# nat pass on $ext_if from $bhyve_tap6 to !$bhyve_net -> $ext_if
# nat pass on $ext_if from $bhyve_tap7 to !$bhyve_net -> $ext_if
# --------------------------


# tap allocations
#
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
ifconfig bridge0 172.25.0.1/16 up
ifconfig bridge0 addm tap0
ifconfig bridge0 addm tap1
ifconfig bridge0 addm tap2
ifconfig bridge0 addm tap3
ifconfig bridge0 addm tap4
# ifconfig bridge0 addm tap5
# ifconfig bridge0 addm tap6
# ifconfig bridge0 addm tap7
