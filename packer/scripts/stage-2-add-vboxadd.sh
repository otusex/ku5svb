#!/bin/bash

cd ~

curl -o vm.iso "http://download.virtualbox.org/virtualbox/6.1.16/VBoxGuestAdditions_6.1.16.iso"

mount -o loop vm.iso /mnt/

yum install -y  centos-release-scl
yum install -y  devtoolset-8

source /opt/rh/devtoolset-8/enable
bash /mnt/VBoxLinuxAdditions.run --nox11

shutdown -r now
