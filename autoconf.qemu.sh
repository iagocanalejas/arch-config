#!/bin/bash

sudo pacman -Suyu

echo "Install required packages"
sudo pacman -S archlinux-keyring
sudo pacman -S qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat ovmf
sudo pacman -S ebtables iptables

echo "Configure archlinuxfr"
sudo echo -e '[archlinuxfr]' >> /etc/pacman.conf
sudo echo -e '[SigLevel = Never]' >> /etc/pacman.conf
sudo echo -e '[Server = http://repo.archlinux.fr/$arch]' >> /etc/pacman.conf

sudo pacman -Syy

echo "Install KVM"
sudo pacman -S libguestfs
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

echo "Enable normal user to use KVM"
sudo sed -i 's/^#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/^#unix_sock_rw_perms = "libvirt"/unix_sock_rw_perms = "libvirt"/' /etc/libvirt/libvirtd.conf
sudo echo -e 'log_filters="1:qemu"' >> /etc/libvirt/libvirtd.conf
sudo echo -e 'log_outputs="1:file:/var/log/libvirt/libvirtd.log"' >> /etc/libvirt/libvirtd.conf

sudo usermod -a -G libvirt $(whoami)
newgrp libvirt
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

sudo sed -i 's/^#user = "root"/user = "$(whoami)"/' /etc/libvirt/qemu.conf
sudo sed -i 's/^#group = "root"/group = "$(whoami)"/' /etc/libvirt/qemu.conf
sudo systemctl restart libvirtd