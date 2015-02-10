#!/bin/bash

# Before running this script:
# 1) Do bare bones installation of server (connected to the two necessary network interfaces).
# 2) Log in, run "yum update && yum install dkms", and configure networking; logout.
# 3) Install guest additions CD-ROM drive for base image in VirtualBox
# 4) Log in again, and in the directory where the cd rom drive is mounted run "./VBoxLinuxAdditions.run"; logout.


# First, set up the environment

source vbox_env.sh


# Import the cluster base image for the chef server and nodes, add a shared folder containing server setup scripts, and configure the servers
VBoxManage import $iso_dir/Cluster_Base.ova --vsys 0 --vmname "Chef Server Centos"
VBoxManage sharedfolder add "Chef Server Centos" --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
VBoxManage startvm "Chef Server Centos" --type headless
VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/fix_networking.sh
VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/chef_server.sh
# May need to wait before the poweroff?
VBoxManage controlvm "Chef Server Centos" poweroff

VBoxManage import $iso_dir/Cluster_Base.ova --vsys 0 --vmname "SolrCloud 1"
VBoxManage sharedfolder add "SolrCloud1" --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
VBoxManage startvm "SolrCloud1" --type headless
VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/fix_networking.sh
VBoxManage controlvm "SolrCloud1" poweroff

VBoxManage import $iso_dir/Cluster_Base.ova --vsys 0 --vmname "SolrCloud 2"
VBoxManage sharedfolder add "SolrCloud2" --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
VBoxManage startvm "SolrCloud2" --type headless
VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/fix_networking.sh
VBoxManage controlvm "SolrCloud2" poweroff

VBoxManage import $iso_dir/Culster_Base.ova --vsys 0 --vmname "SolrCloud 3"
VBoxManage sharedfolder add "SolrCloud3" --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
VBoxManage startvm "SolrCloud3" --type headless
VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/fix_networking.sh
VBoxManage controlvm "SolrCloud3" poweroff







