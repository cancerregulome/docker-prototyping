#!/bin/bash

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

SET home_dir=C:\Users\Abby

# The ipaddress of the machine that will be serving the boot files over the network
SET host_ip=192.168.76.2

# The directory where all of your ISO files live
SET iso_dir=$home_dir\Desktop\ISB

# The name of the .ova image file to import
SET cluster_base=Cluster_Base

# The directory where VirtualBox stores vms, by default
SET vbox_vm_dir=$home_dir\VirtualBox VMs

# The VirtualBox TFTP directory (you probably won't need to change this)
SET vbox_tftp_dir=$home_dir\.VirtualBox\TFTP

# The test infrastructure setup root directory (i.e., the absolute path to the location on your local machine where you have copied the test_infrastructure_setup directory)
SET setup_dir=$home_dir\Desktop\ISB\test_infrastructure_setup

# The directory functioning as a shared volume between VMs and the host 
SET vbox_share=$home_dir\Desktop\ISB\test_infrastructure_setup\setup_scripts

# Location of the Linux Guest Additions iso file
SET guest_additions=C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso

:BaseImagePrompt
# Ask the user if they want to create a new base image to clone from
SET /P yn Would you like to create a new VirtualBox base image to clone from? [Y|N]
IF "%yn%" == "Y" || "%yn%" == "y" (
	GOTO BaseImageSelect
) ELSE (
	IF "%yn%" == "N" || "%yn%" == "n" (
		GOTO NetworkPrompt
	) ELSE (
		ECHO That wasn't a valid choice.
		GOTO BaseImagePrompt
	)
)  

:BaseImageSelect

base_image_select () {
	# Ask the user which base image they want to create
	ECHO "Which base image would you like to create?"
	ECHO "	[1] Centos6.6"
	SET /P base_image Enter a number:
	
	IF "%base_image%" == "1" (
		GOTO Centos6BaseCreate
	) ELSE (
		ECHO That wasn't a valid choice.
		GOTO BaseImageSelect
	)
}

:NetworkPrompt
# Ask the user if they want to create a new network for the VMs
read /P yn "Would you like to create a new local network for your Virtualbox cluster? [Y/N] "
IF "%yn%" == "Y" || "%yn%" == "y" (
	GOTO NetworkCreate
) ELSE (
	IF "%yn% == "N" || "%yn%" == "n" (
		GOTO ChefServerPrompt
	) ELSE (
		ECHO That wasn't a valid choice.
		GOTO NetworkPrompt
	)
)

:NetworkCreate

:Centos6BaseCreate
centos6_base_create () {
	# Create the necessary directories and bootfiles
	IF NOT EXISTS %vbox_tftp_dir%/images/RHEL/x86_64/6.6 (
		MD %vbox_tftp_dir%/images/RHEL/x86_64/6.6 
	)

	COPY %setup_dir%/centos6_boot_files/initrd.img %setup_dir%/centos6_boot_files/vmlinuz %vbox_tftp_dir%/images/RHEL/x86_64/6.6

	IF NOT EXISTS %vbox_tftp_dir%/pxelinux.cfg (
		MD %vbox_tftp_dir%/pxelinux.cfg
	)
	
	COPY %setup_dir%/centos6_boot_files/pxelinux.0 %vbox_tftp_dir%/$cluster_base.pxe

	ECHO "LABEL centos6.6" > %vbox_tftp_dir%/pxelinux.cfg/default
	ECHO "	KERNEL images/RHEL/x86_64/6.6/vmlinuz"  >> %vbox_tftp_dir%/pxelinux.cfg/default
	ECHO "	APPEND initrd=images/RHEL/x86_64/6.6/initrd.img ks=http://%host_ip%/anaconda-ks.cfg" >> %vbox_tftp_dir%/pxelinux.cfg/default
	
	# Create the centos6 base vm
	VBoxManage createvm --name $cluster_base --ostype "RedHat_64" --register
	## Add network interfaces and memory
	VBoxManage modifyvm $cluster_base --memory 2048 --nic1 natnetwork --nat-network1 NatNetwork --nic2 hostonly --hostonlyadapter1 Virtual\ Box\ Host-Only\ Ethernet\ Adapter 
	## Create a hard drive
	VBoxManage createhd --filename $cluster_base.vdi --size 20000
	## Create and attach storage devices and Linux Guest Additions
	VBoxManage storagectl $cluster_base --name IDE1 --add ide  --bootable on
	VBoxManage storageattach $cluster_base --storagectl IDE1 --port 0 --device 0 --type dvddrive --medium $iso_dir/CentOS-6.6-x86_64-minimal.iso
	VBoxManage storagectl $cluster_base --name SATA --add sata  #--bootable on
	VBoxManage storageattach $cluster_base --storagectl SATA --port 1 --device 0 --type hdd --medium $cluster_base.vdi
	## Modify the boot order
	VBoxManage modifyvm $cluster_base --boot1 disk --boot2 net --boot3 none --boot4 none
	# Start the VM
	VBoxManage startvm $cluster_base
	
	#VBoxManage storagectl $cluster_base --name IDE2 --add ide --bootable off
	#VBoxManage storageattach $cluster_base --storagectl IDE2 --port 0 --device 1 --type dvddrive --medium $guest_additions
}

:ChefServerPrompt
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

:ChefNodePrompt
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







