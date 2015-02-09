#!/bin/bash

# Create networks for the vms to connect to
VBoxManage natnetwork add --netname NatNetwork1 --enable --dhcp on
VBoxManage hostonlyif --dhcp create vboxnet0 
VBoxManage dhcpserver add --ip 192.168.56.100 --netmask 255.255.255.0 --lowerip 192.168.56.101 --upperip 192.168.56.254 --enable

# Create a VM for the chef server
VBoxManage createvm --name "Chef Server Centos" --ostype "RedHat_64" --register
VBoxManage modifyvm "Chef Server Centos" --memory 2048 --nic1 natnetwork --nat-network1 NatNetwork1 --nic2 hostonly --hostonlyadapter1 vboxnet0 
VBoxManage createhd --filename "Chef Server Centos.vdi" --size 20000
VBoxManage storagectl "Chef Server Centos" --name IDE --add ide 
VBoxManage storageattach "Chef Server Centos" --storagectl IDE --port 0 --device 0 --type dvddrive --medium "/Users/ahahn/Desktop/CentOS-6.6-x86_64-minimal.iso"
VBoxManage storagectl "Chef Server Centos" --name SATA --add sata 
VBoxManage storageattach "Chef Server Centos" --storagectl SATA --port 0 --device 0 --type hdd --medium "Chef Server Centos.vdi"

# Create VMs for the chef nodes
VBoxManage createvm --name "SolrCloud_1" --ostype "RedHat_64" --register
VBoxManage modifyvm "SolrCloud_1" --memory 2048 --nic1 natnetwork --nat-network1 NatNetwork1 --nic2 hostonly --hostonlyadapter1 vboxnet0 

VBoxManage createvm --name "SolrCloud_2" --ostype "RedHat_64" --register
VBoxManage modifyvm "SolrCloud_2" --memory 2048 --nic1 natnetwork --nat-network1 NatNetwork1 --nic2 hostonly --hostonlyadapter1 vboxnet0

VBoxManage createvm --name "SolrCloud_3" --ostype "RedHat_64" --register
VBoxManage modifyvm "SolrCloud_3" --memory 2048 --nic1 natnetwork --nat-network1 NatNetwork1 --nic2 hostonly --hostonlyadapter1 vboxnet0





