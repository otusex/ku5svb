#!/bin/bash

cd /usr/src/kernels/
# update packeges
yum update -y

# install  bc
yum install bc -y

# install repo epel-release
yum install -y epel-release

# install Dev tools
yum groupinstall 'Development Tools' -y

# Required to install the kernel from source
yum install -y  openssl-devel elfutils-libelf-devel


# Install gcc 8.x for  install the kernel 5.x from source
yum install -y  centos-release-scl devtoolset-8
yum install -y  devtoolset-8
source /opt/rh/devtoolset-8/enable

# Download source kernel
curl -o kernel.tgz  "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.9.3.tar.xz"

tar -xf kernel.tgz

curl -o patch.xz https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-5.9.3.xz

unxz patch.xz

cd linux-5*

patch -R -p1 < ../patch

# Use old kernel config
cp /boot/config* .config
yes "" | make oldconfig

# assembly kernel, modules, headers, firmware
make -j4 &&  make modules -j4 && make modules_install -j4 && make headers_install ARCH=x86_64 INSTALL_HDR_PATH=/usr -j4  &&  make install -j 4



# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg && grub2-set-default 0

echo "Grub update done."
# Reboot VM
shutdown -r now
