#!/bin/bash

# First, set up the environment

source vbox_env.sh

# Import the cluster base image for the chef server and nodes
VBoxManage import $iso_dir/Cluster_Base.ova --vsys 0 --vmname "Chef Server Centos"

VBoxManage import $iso_dir/Cluster_Base.ova --vsys 0 --vmname "SolrCloud 1"

VBoxManage import $iso_dir/Cluster_Base.ova --vsys 0 --vmname "SolrCloud 2"

VBoxManage import $iso_dir/Culster_Base.ova --vsys 0 --vmname "SolrCloud 3"

# Network Setup
## Copy setup scripts to guest

## Run the setup scripts


###########################################################################################
# Create a VM for the chef server
VBoxManage createvm --name "Chef Server Centos" --ostype "RedHat_64" --register
## Add network interfaces and memory
VBoxManage modifyvm "Chef Server Centos" --memory 2048 --nic1 natnetwork --nat-network1 NatNetwork1 --nic2 hostonly --hostonlyadapter1 vboxnet0 
## Create a hard drive
VBoxManage createhd --filename "Chef Server Centos.vdi" --size 20000
## Create and attach storage devices
VBoxManage storagectl "Chef Server Centos" --name IDE --add ide 
VBoxManage storageattach "Chef Server Centos" --storagectl IDE --port 0 --device 0 --type dvddrive --medium $iso_dir/CentOS-6.6-x86_64-minimal.iso
VBoxManage storagectl "Chef Server Centos" --name SATA --add sata 
VBoxManage storageattach "Chef Server Centos" --storagectl SATA --port 0 --device 0 --type hdd --medium "$vbox_dir/Chef Server Centos/Chef Server Centos.vdi"

# Create VMs for the chef nodes
## SolrCloud_1
VBoxManage createvm --name "SolrCloud_1" --ostype "RedHat_64" --register
VBoxManage modifyvm "SolrCloud_1" --memory 2048 --nic1 natnetwork --nat-network1 NatNetwork1 --nic2 hostonly --hostonlyadapter1 vboxnet0 
## Create a hard drive
VBoxManage createhd --filename "SolrCloud_1.vdi" --size 20000
## Create and attach storage devices
VBoxManage storagectl "SolrCloud_1" --name IDE --add ide 
VBoxManage storageattach "SolrCloud_1" --storagectl IDE --port 0 --device 0 --type dvddrive --medium $iso_dir/CentOS-6.6-x86_64-minimal.iso
VBoxManage storagectl "SolrCloud_1" --name SATA --add sata 
VBoxManage storageattach "SolrCloud_1" --storagectl SATA --port 0 --device 0 --type hdd --medium $vbox_dir/SolrCloud_1/SolrCloud_1.vdi

## SolrCloud_2
VBoxManage createvm --name "SolrCloud_2" --ostype "RedHat_64" --register
VBoxManage modifyvm "SolrCloud_2" --memory 2048 --nic1 natnetwork --nat-network1 NatNetwork1 --nic2 hostonly --hostonlyadapter1 vboxnet0
## Create a hard drive
VBoxManage createhd --filename "SolrCloud_2.vdi" --size 20000
## Create and attach storage devices
VBoxManage storagectl "SolrCloud_2" --name IDE --add ide 
VBoxManage storageattach "SolrCloud_2" --storagectl IDE --port 0 --device 0 --type dvddrive --medium $iso_dir/CentOS-6.6-x86_64-minimal.iso
VBoxManage storagectl "SolrCloud_2" --name SATA --add sata 
VBoxManage storageattach "SolrCloud_2" --storagectl SATA --port 0 --device 0 --type hdd --medium "$vbox_dir/SolrCloud_2/SolrCloud_2.vdi"

## SolrCloud_3
VBoxManage createvm --name "SolrCloud_3" --ostype "RedHat_64" --register
VBoxManage modifyvm "SolrCloud_3" --memory 2048 --nic1 natnetwork --nat-network1 NatNetwork1 --nic2 hostonly --hostonlyadapter1 vboxnet0
## Create a hard drive
VBoxManage createhd --filename "SolrCloud_3.vdi" --size 20000
## Create and attach storage devices
VBoxManage storagectl "SolrCloud_3" --name IDE --add ide 
VBoxManage storageattach "SolrCloud_3" --storagectl IDE --port 0 --device 0 --type dvddrive --medium $iso_dir/CentOS-6.6-x86_64-minimal.iso
VBoxManage storagectl "SolrCloud_3" --name SATA --add sata 
VBoxManage storageattach "SolrCloud_3" --storagectl SATA --port 0 --device 0 --type hdd --medium "$vbox_dir/SolrCloud_3/SolrCloud_3.vdi"





