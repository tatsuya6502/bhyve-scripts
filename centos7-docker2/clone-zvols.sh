#!/bin/sh

SNAPSHOT_NAME=180808-d2-base

SRC_DISK1=zdata77/bhyve/cent7d1/disk1
SRC_DISK2=zroot/bhyve/cent7d1/disk2
TGT_DISK1=zdata77/bhyve/cent7d2/disk1
TGT_DISK2=zroot/bhyve/cent7d2/disk2

# Are you sure?


set -ex

# zfs destroy ..

zfs clone ${SRC_DISK1}@${SNAPSHOT_NAME} $TGT_DISK1
zfs clone ${SRC_DISK2}@${SNAPSHOT_NAME} $TGT_DISK2
