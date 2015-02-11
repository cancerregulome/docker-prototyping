#!/bin/bash

# Before running this script:
# 1) Do bare bones installation of server (connected to the two necessary network interfaces).
# 2) Log in, run "yum update && yum install dkms", and configure networking; logout.
# 3) Install guest additions CD-ROM drive for base image in VirtualBox
# 4) Log in again, and in the directory where the cd rom drive is mounted run "./VBoxLinuxAdditions.run"; logout.

# First, set up the environment

source vbox_env.sh

vbox_network_create () {
	# Create the network
	VBoxManage natnetwork add --netname NatNetwork1 --enable --dhcp on
	VBoxManage hostonlyif --dhcp create vboxnet0 
	VBoxManage dhcpserver add --ip 192.168.56.100 --netmask 255.255.255.0 --lowerip 192.168.56.101 --upperip 192.168.56.254 --enable
}

chef_server_create () {
	# Import the cluster base image for the chef server and nodes, add a shared folder containing server setup scripts, and configure the servers
	VBoxManage import $iso_dir/Cluster_Base.ova --vsys 0 --vmname "Chef Server Centos"
	VBoxManage sharedfolder add "Chef Server Centos" --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
	VBoxManage startvm "Chef Server Centos" --type headless
	VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/fix_networking.sh
	VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/chef_server.sh
	# May need to wait before the poweroff?
	VBoxManage controlvm "Chef Server Centos" poweroff
}

chef_node_create () {
	node_name=ChefNode$1
	VBoxManage import $iso_dir/$cluster_base --vsys 0 --vmname $node_name
	VBoxManage sharedfolder add $node_name --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
	VBoxManage startvm $node_name --type headless
	VBoxManage guestcontrol $node_name execute --image /media/sf_vm_setup_scripts/fix_networking.sh
	VBoxManage guestcontrol $node_name execute --image /media/sf_vm_setup_scripts/fix_hosts_file.sh
	VBoxManage controlvm $node_name poweroff
}
# Ask the user if they want to create a new network
read -p "Would you like to create a new local network for your Virtualbox cluster? [Y/N] " yn
while true; do
	case $yn in
		Y|y)
			network_create;;
		N|n)
			break;;
		*)
	esac
done

# Ask the user if they want to create a new chef server
read -p "Would you like to create a new chef server? [Y/N] " yn

while true; do
	case $yn in
		Y|y)
			chef_server_create;;
		N|n)
			break;;
		*)
	esac
done

read -p "How many chef nodes would you like to create? " node_num

if [[ -z "$node_num" ]]; then
	read -p "Please enter a number of nodes greater or equal to zero: " node_num
else
	count=0

	while [[ $count < $node_num ]]; do
		chef_node_create $node_num
		((count += 1))
	done
fi







