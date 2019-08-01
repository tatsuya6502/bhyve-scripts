# bhyve-scripts

A collection of very simple shell scripts to run bhyve VMs on my
FreeBSD desktop and server machines.

You may need to edit them to fit your needs. But I hope they will
serve as examples where you can get start with.

Open-sourced under the MIT Licence.


## Environment

### Host Machines

- **FreeBSD 10.2-RELEASE**
- ZFS zvols as the virtual disks for bhyve VMs
- Bridged tap devices for network access

### Guest Machines

- **Linux Guests:**
  * RHEL 7
  * CentOS 7
  * CentOS 6
  * Ubuntu 14.04 LTS
  * (**TODO**) CoreOS, with btrfs or overlayfs backend

- **BSD Guests:**
  * OpenBSD 5.8
  * (**TODO**) FreeBSD 11.0-CURRENT

- **illumos Guests:**
  * (**TODO**) SmartOS


**NOTES:**

- Of course, FreeBSD guests are supported but I just do not need them
  right now. When I have more time, I will create one for playing with
  FreeBSD-11.0-CURRENT running [Docker]()
  on 64-bit Linux binary support.
- Fedora 2X and Arch Linux did not run when I tried them in early 2015.
- SmartOS (illumos) guests are supported but currently only in FreeBSD
  HEAD I think.
  * []()
  * []()
- Head-less Windows Server is supported in FreeBSD HEAD, but I have no
  need for it.


### ZFS zvols

These `disk1` are thin-provisioned zvols.

```shell-session
$ zfs list -r zroot/bhyve
NAME                                    USED  AVAIL  REFER  MOUNTPOINT
zroot/bhyve                            107G   364G   144K  none
zroot/bhyve/centos6-vertica           49.7G   364G    96K  none
zroot/bhyve/centos6-vertica/disk1     49.7G   364G  41.2G  -
zroot/bhyve/centos7-docker1           38.2G   364G   144K  none
zroot/bhyve/centos7-docker1/disk1     38.2G   364G  32.3G  -
zroot/bhyve/openbsd                    969M   364G    96K  none
zroot/bhyve/openbsd/disk1              969M   364G   969M  -
zroot/bhyve/rhel7-ost-icehouse        7.55G   364G   144K  none
zroot/bhyve/rhel7-ost-icehouse/disk1  7.55G   364G  8.27G  -
zroot/bhyve/rhel7-ost-juno            5.20G   364G   144K  none
zroot/bhyve/rhel7-ost-juno/disk1      5.20G   364G  4.76G  -
zroot/bhyve/ubuntu-14.04              5.00G   364G   144K  none
zroot/bhyve/ubuntu-14.04/disk1        5.00G   364G  5.00G  -
```

```shell-session
$ sudo zfs create zroot/bhyve/centos7-docker1
$ sudo zfs create -V 48G -s zroot/bhyve/centos7-docker1/disk1
```

#### TIPS: Snapshot and Cloned Volumes

After installing an OS, you may want to take a snapshot of the zvol.

```shell-session
$ SNAP_DATE=2016-01-01
$ sudo zfs snapshot zroot/bhyve/centos7/disk1@${SNAP_DATE}
```

Also, it is a good idea to use cloned zvols.

```shell-session
$ BASEIMAGE_DATE=2016-01-01
$ sudo zfs create zroot/bhyve/centos7-docker1
$ sudo zfs clone zroot/bhyve/centos7/disk1@${BASEIMAGE_DATE} \
                 zroot/bhyve/centos7-docker1/disk1
```


## Prerequisites

(**TODO**) Install grub-bhyve2 etc.

bhyve-firmware

https://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/virtualization-host-bhyve.html

## Load Kernel Modules and Create Tap Devices

Run the following script to load the kernel modules for bhyve and
create tap devices for the VMs.

```shell-session
$ cat ./setup.sh
#!/bin/sh

kldload if_tap
kldload if_bridge
kldload vmm
kldload nmdm
sysctl net.link.tap.up_on_open=1
sysctl net.inet.ip.forwarding=1

ifconfig tap0 create
ifconfig tap1 create
...

ifconfig bridge0 create
ifconfig bridge0 addm bge0 addm tap0 addm tap1 up
...
```

```shell-session
$ sudo ./setup.sh
```


**TODO:** Check if I can remove the following command.

```setup.sh
sysctl net.inet.ip.forwarding=1
```


## Installing Linux -- Booting a VM from installer ISO Image

Edit `device.map`.

```bhyve-scripts/centos7/device.map
(hd0) /dev/zvol/zroot/bhyve/centos7-docker1/disk1
(cd0) /home/tatsuya/installers/centos/CentOS-7.0-1406-x86_64-DVD.iso
```

Run `grub-bhyve` as root.

```shell-session
$ cd centos7
$ sudo grub-bhyve -m device.map -r cd0 -M 4096M centos7-docker1
grup> ls
(hd0) (hd0,msdos2) (hd0,msdos1) (cd0) (cd0,msdos2) (host) (lvm/centos-root) (lvm/centos-swap)
grub> ls (cd0)/
CentOS_BuildTag EFI/ EULA GPL images/ isolinux/ LiveOS/ Packages/
repodata/ RPM-GPG-KEY-CentOS-Testing-7 RPM-GPG-KEY-CentOS-7 TRANS.TBL
grup> ls (cd0)/isolinux
boot.cat boot.msg grub.conf initrd.img isolinux.bin isolinux.cfg
memtest splash.png TRANS.TBL upgrade.img vesamenu.c32 vmlinuz

grub> linux (cd0)/isolinux/vmlinuz
grub> initrd (cd0)/isolinux/initrd.img
grub> boot
```

**NOTE:**

For CentOS, it's recommended to perform VNC-based graphical
installation rather than console-based installation because graphical
one gives you more customization options (e.g. custom disk layout)
To do that, add the following options to +linux+ command.

```shell-session
grub> linux (cd0)/isolinux/vmlinuz vnc headless ip=dhcp ksdevice=eth0 lang=en_US keymap=us
```

Once the installer started, it will give tell you VNC server address
and port.

For example, you will see the following message:

```shell-session
Please manually connect your vnc client to 10.0.0.117:1 to begin the install.
```

Run +bhyve+ as root. Note that the VM has the installer DVD ISO
attached (`-s 3,...`).

Change `-s 2,... tap1` and DVD and disk1 locations.

```shell-session
$ sudo bhyve -c 4 -m 4096M -H -P -A -l com1,stdio \
    -s 0:0,hostbridge -s 1:0,lpc \
    -s 2:0,virtio-net,tap1 \
    -s 3,ahci-cd,/home/tatsuya/installers/centos/CentOS-7.0-1406-x86_64-DVD.iso \
    -s 4,virtio-blk,/dev/zvol/zroot/bhyve/centos7-docker1/disk1 \
    centos7-docker1
```shell-session

When installation is completed, shutdown the VM. (In CentOS
installation, press the "Restart" button. This will shutdown the VM
and drop you into a shell prompt (instead of restarting). Proceed to
next chapter to boot the VM from the disk image.


## Booting a Linux VM from The zvol Disk Image

```shell-session
$ cd centos7
```

Edit +grub.in+. You might want to take a look at grub menu for kernel
parameters.


Run the VM in a `tmux` or `screen` session.

```shell-session
$ tmux
$ sudo ./run.sh
```

**TODO:** Use null modems rather than running in a `tmux` or `screen` session.


## Installing OpenBSD -- Booting a VM from installer ISO Image

Edit `device.map`.

```bhyve-scripts/openbsd/device.map
(hd0) /dev/zvol/zroot/bhyve/openbsd/disk1
(cd0) /home/tatsuya/installers/openbsd/openbsd-5.7/install57.iso
```

Run `grub-bhyve` as root. Boot with the OpenBSD install kernel (`bsd.rd`).

```shell-session
$ cd openbsd
$ sudo grub-bhyve -m device.map -r cd0 -M 256M openbsd
grup> ls
(hd0) (cd0) (host)
grub> ls (cd0)/
5.7/ etc/ TRANS.TBL
grup> ls (cd0)/5.7
amd64/ TRANS.TBL
grub> ls (cd0)/5.7/amd64/
base57.tgz boot.catalog bsd bsd.mp bsd.rd cdboot cdbr comp57.tgz
game57.tgz INSTALL.amd64 man57.tgz SHA256 TRANS.TBL xbase57.tgz
xfont57.tgz xserv57.tgz xshare57.tgz

grub> kopenbsd -h com0 (cd0)/5.7/amd64/bsd.rd
grub> boot
```

**NOTE**: [Example](https://forums.freebsd.org/threads/howto-bhyve-using-openbsd-as-main-firewall-in-freebsd.50470/#post-282880)


Run `bhyve` as root. Note that the VM has the installer ISO attached.
Also it seems `-W` option is required. It forces virtio to use
single-vector MSI.

```shell-session
$ sudo bhyve -W -m 256M -H -P -A -l com1,stdio \
    -s 0:0,hostbridge \
    -s 1:0,lpc \
    -s 2:0,virtio-net,tap4 \
    -s 3,ahci-cd,/home/tatsuya/installers/openbsd/openbsd-5.7/install57.iso \
    -s 4,virtio-blk,/dev/zvol/zroot/bhyve/openbsd/disk1 \
    openbsd
```


## TIPS

### IMPORTANT: Check and adjust the System Clock

When you boot up a VM, login to the VM and *check if system clock is
correct*. By some reason it's usually advance 3 days, so `ntpd` won't
be able to adjust the clock. Run `ntpdate` to fix it.

```shell-session
$ sudo systemctl stop ntpd.service
$ sudo ntpdate -b pool.ntp.org
$ sudo systemctl start ntpd.service
----

**NOTE**: This might be fixed in 10.2-RELEASE
([Reference](https://www.quernus.co.uk/2015/07/27/openbsd-as-freebsd-router/#comment-2163062052))


### Using the Latest Linux Kernel

When Linux Kernel in a VM is updated, edit `grub.in` so that it will
boot from the latest one.

```.bhyve-scripts/centos7/grub.in
linux (hd0,msdos1)/vmlinuz-3.10.0-123.20.1.el7.x86_64 root=/dev/mapper/centos-root
initrd (hd0,msdos1)/initramfs-3.10.0-123.20.1.el7.x86_64.img
boot
```
