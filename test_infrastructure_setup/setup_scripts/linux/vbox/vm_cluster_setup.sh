#!/bin/bash -e

# Before running this script:
# 1) Do bare bones installation of server (connected to the two necessary network interfaces).
# 2) Log in, run "yum update && yum install dkms", and configure networking; logout.
# 3) Install guest additions CD-ROM drive for base image in VirtualBox
# 4) Log in again, and in the directory where the cd rom drive is mounted run "./VBoxLinuxAdditions.run"; logout.

#verify_virtualbox () {
	# Determine if the correct version of VirtualBox is installed
	
#}

#verify_apache () {
	# Change to verify_apache
	# ping webserver on expected port
#}

base_image_select () {
	# Ask the user which base image they want to create
	echo "Which base image would you like to create?"
	echo "	[1] Centos6.6"
	read -p "Enter a number: " base_image
	
	while true; do
		if [[ -z "$base_image" ]]; then # this condition isn't very robust -- fix later
			echo "Please choose a base image to create:"
			echo "	[1] Centos6.6"
			read -p "Enter a number: " base_image
		else
			break
		fi
	done

	case $base_image in
		1)
			centos6_base_create;;
		*)
	esac
}

centos6_base_create () {
	# Create the centos6 base vm
	VBoxManage createvm --name $cluster_base --ostype "RedHat_64" --register
	## Add network interfaces and memory
	echo "made it"
	VBoxManage modifyvm $cluster_base --memory 2048 --vram 12 
	#VBoxManage modifyvm $cluster_base --nic1 natnetwork --nat-network1 NatNetwork --nic2 hostonly --hostonlyadapter2 vboxnet0
	## Configure TFTP
	VBoxManage modifyvm $cluster_base --natdnshostresolver1 on --nattftpprefix1 $vbox_tftp_dir 
	## Create a hard drive
	VBoxManage createhd --filename $cluster_base.vdi --size 20000
	## Create and attach storage devices
	VBoxManage storagectl $cluster_base --name IDE --add ide  --bootable on
	VBoxManage storageattach $cluster_base --storagectl IDE --port 0 --device 0 --type dvddrive --medium $iso_dir/CentOS-6.6-x86_64-minimal.iso
	VBoxManage storagectl $cluster_base --name SATA --add sata  #--bootable on
	VBoxManage storageattach $cluster_base --storagectl SATA --port 1 --device 0 --type hdd --medium $cluster_base.vdi
	## Modify the boot order
	VBoxManage modifyvm $cluster_base --boot1 net --boot2 none --boot3 none --boot4 none
	
	# Get the UUID of the VM
	
	#uuid=`VBoxManage showvminfo $cluster_base | awk '/UUID/ {print $2}' | head -n 1`
	
	# Create the necessary directories and bootfiles
	if [[ ! -d $vbox_tftp_dir/images/RHEL/x86_64/6.6 ]]; then
		mkdir -p $vbox_tftp_dir/images/RHEL/x86_64/6.6
	fi

	cp $setup_dir/centos6_boot_files/initrd.img $setup_dir/centos6_boot_files/vmlinuz $vbox_tftp_dir/images/RHEL/x86_64/6.6

	if [[ ! -d $vbox_tftp_dir/pxelinux.cfg ]]; then
		mkdir $vbox_tftp_dir/pxelinux.cfg
	fi
	
	cp $setup_dir/centos6_boot_files/pxelinux.0 $vbox_tftp_dir/$cluster_base.pxe
	
	if [[ ! -d $vbox_tftp_dir/kickstart ]]; then
		mkdir $vbox_tftp_dir/kickstart
	fi
	
	cp $setup_dir/centos6_boot_files/anaconda-ks.cfg $setup_dir/centos6_boot_files/menu.c32 $vbox_tftp_dir

	#echo "LABEL centos6.6" > $vbox_tftp_dir/pxelinux.cfg/$uuid
	#echo "LABEL centos6.6" > $vbox_tftp_dir/pxelinux.cfg/default
	echo "DEFAULT centos6.6" > $vbox_tftp_dir/pxelinux.cfg/default
	echo "LABEL centos6.6" >> $vbox_tftp_dir/pxelinux.cfg/default
	echo "KERNEL images/RHEL/x86_64/6.6/vmlinuz" >> $vbox_tftp_dir/pxelinux.cfg/default
	echo "APPEND initrd=images/RHEL/x86_64/6.6/initrd.img ks=http://$tftp_host/anaconda-ks.cfg" >> $vbox_tftp_dir/pxelinux.cfg/default
	
	# Copy the necessary files to the apache document root
	cp -R $setup_dir/centos6_boot_files/* $apache_doc_root
	
	# Start the VM
	VBoxManage startvm $cluster_base
	
	#VBoxManage storagectl $cluster_base --name IDE2 --add ide --bootable off
	#VBoxManage storageattach $cluster_base --storagectl IDE2 --port 0 --device 1 --type dvddrive --medium $guest_additions
}

vbox_network_create () {
	# Create the network
	VBoxManage natnetwork add --netname NatNetwork1 --enable --dhcp on
	VBoxManage hostonlyif --dhcp create vboxnet0 
	VBoxManage dhcpserver add --ip 192.168.56.100 --netmask 255.255.255.0 --lowerip 192.168.56.101 --upperip 192.168.56.254 --enable
}

chef_server_create () {
	# Import the cluster base image for the chef server and nodes, add a shared folder containing server setup scripts, and configure the servers
	VBoxManage import $iso_dir/$cluster_base.ova --vsys 0 --vmname "Chef Server Centos"
	VBoxManage sharedfolder add "Chef Server Centos" --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
	VBoxManage startvm "Chef Server Centos" --type headless
	VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/fix_networking.sh
	VBoxManage guestcontrol execute --image /media/sf_vm_setup_scripts/chef_server.sh
	# May need to wait before the poweroff?
	VBoxManage controlvm "Chef Server Centos" poweroff
}

chef_node_create () {
	node_name=ChefNode$1
	VBoxManage import $iso_dir/$cluster_base.ova --vsys 0 --vmname $node_name
	VBoxManage sharedfolder add $node_name --name "vm_setup_scripts" --hostpath $vbox_share --transient --automount
	VBoxManage startvm $node_name --type headless
	VBoxManage guestcontrol $node_name execute --image /media/sf_vm_setup_scripts/fix_networking.sh
	VBoxManage guestcontrol $node_name execute --image /media/sf_vm_setup_scripts/fix_hosts_file.sh
	VBoxManage controlvm $node_name poweroff
}

# If VirtualBox isn't installed, install it
#verify_virtualbox

# If Apache isn't installed, install it
#verify_apache

# Setup the environment

source vbox_env.sh


# Configure and start the Apache webserver to serve boot files during the PXE boot process in VirtualBox

# Ask the user if they want to create a new base image to clone from
read -p "Would you like to create a new VirtualBox base image to clone from? [Y|N] " yn
while true; do
	case $yn in 
		Y|y)
			base_image_select
			break;;
		N|n)
			break;;
		*)
	esac
done

# Ask the user if they want to create a new network for the VMs
read -p "Would you like to create a new local network for your Virtualbox cluster? [Y/N] " yn
while true; do
	case $yn in
		Y|y)
			network_create
			break;;
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
			chef_server_create
			break;;
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







