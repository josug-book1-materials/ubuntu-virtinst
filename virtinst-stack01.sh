#!/bin/bash

TOP_DIR=$(cd $(dirname "$0") && pwd)

NAME=stack01
RELEASE_NAME=trusty
NUM_CPU=2
MEMORY=8192
ARCH=amd64
VIRT_ARCH=x86_64

SITE=http://ftp.riken.go.jp/Linux/ubuntu
LOCATION=$SITE/dists/$RELEASE_NAME/main/installer-$ARCH/
#LOCATION=/home/ubuntu/iso/ubuntu/ubuntu-14.04.1-server-amd64.iso

IMAGEDIR=/var/lib/libvirt/images
DISK1FORMAT=raw
DISK1SIZE=64
DISK1FILE=$IMAGEDIR/$NAME.img

sudo virt-install \
    --name $NAME \
    --cpu host \
    --os-type linux \
    --os-variant ubuntu${RELEASE_NAME} \
    --connect=qemu:///system \
    --vcpus $NUM_CPU \
    --ram $MEMORY \
    --serial pty \
    --console pty \
    --disk=$DISK1FILE,format=$DISK1FORMAT,size=$DISK1SIZE,sparse=true \
    --nographics \
    --location $LOCATION \
    --network network=management,model=virtio \
    --network network=internal,model=virtio \
    --network network=external,model=virtio \
    --initrd-inject $TOP_DIR/stack01/preseed.cfg \
    --extra-args "
console=ttyS0,115200
file=/preseed.cfg
auto=true
priority=critical
interface=auto
language=en
country=JP
locale=en_US.UTF-8
console-setup/layoutcode=jp
console-setup/ask_detect=false
DEBCONF_DEBUG=5
"
