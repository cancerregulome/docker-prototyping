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
	# Create the necessary directories and bootfiles
	if [[ ! -d $vbox_tftp_dir/images/RHEL/x86_64/6.6 ]]; then
		mkdir -p $vbox_tftp_dir/images/RHEL/x86_64/6.6
	fi

	cp $setup_dir/centos6_boot_files/initrd.img $setup_dir/centos6_boot_files/vmlinuz $vbox_tftp_dir/images/RHEL/x86_64/6.6

	if [[ ! -d $vbox_tftp_dir/pxelinux.cfg ]]; then
		mkdir -p $vbox_tftp_dir/pxelinux.cfg
	fi
	
	cp $setup_dir/centos6_boot_files/pxelinux.0 $vbox_tftp_dir/$cluster_base.pxe
	
	if [[ ! -d $vbox_tftp_dir ]]; then
		mkdir -p $vbox_tftp_dir
	fi
	
	#cp $setup_dir/centos6_boot_files/anaconda-ks.cfg $setup_dir/centos6_boot_files/menu.c32 $vbox_tftp_dir

	echo "DEFAULT centos6.6" > $vbox_tftp_dir/pxelinux.cfg/default
	echo "LABEL centos6.6" >> $vbox_tftp_dir/pxelinux.cfg/default
	echo "KERNEL images/RHEL/x86_64/6.6/vmlinuz" >> $vbox_tftp_dir/pxelinux.cfg/default
	echo "APPEND initrd=images/RHEL/x86_64/6.6/initrd.img ks=http://$tftp_host/anaconda-ks.cfg ksdevice=eth0 apm=power_off" >> $vbox_tftp_dir/pxelinux.cfg/default

	# Set up the directory for exported base images
	if [[ ! -d $chef_cluster_base_dir ]]; then 
		mkdir -p $chef_cluster_base_dir
	fi
	
	# Copy the necessary files to the apache document root
	cp -R $setup_dir/centos6_boot_files/anaconda-ks.cfg $apache_doc_root

	# Create the centos6 base vm
	# Note to self:  Figure out why this is creating the .vdi in cwd
	VBoxManage createvm --name $cluster_base --ostype "RedHat_64" --register 
	## Add network interfaces and memory, and enable ACPI
	VBoxManage modifyvm $cluster_base --memory 2048 --vram 12 --acpi on
	VBoxManage modifyvm $cluster_base --nic1 nat --nic2 hostonly --hostonlyadapter2 vboxnet0
	## Configure TFTP
	VBoxManage modifyvm $cluster_base --natdnshostresolver1 on --nattftpprefix1 $vbox_tftp_dir 
	## Create a hard drive
	VBoxManage createhd --filename $cluster_base.vdi --size 20000
	## Create and attach storage devices (CentOS and Guest Additions images)
	VBoxManage storagectl $cluster_base --name IDE --add ide
	VBoxManage storageattach $cluster_base --storagectl IDE --port 0 --device 0 --type dvddrive --medium $iso_dir/CentOS-6.6-x86_64-minimal.iso
	VBoxManage storageattach $cluster_base --storagectl IDE --port 1 --device 1 --type dvddrive --medium $guest_additions
	VBoxManage storagectl $cluster_base --name SATA --add sata  
	VBoxManage storageattach $cluster_base --storagectl SATA --port 0 --device 0 --type hdd --medium $cluster_base.vdi
	## Modify the boot order
	VBoxManage modifyvm $cluster_base --boot1 disk --boot2 net --boot3 none --boot4 none
	
	# Start the VM
	VBoxManage startvm $cluster_base --type headless
	
	# Wait fot the installation to finish
	until $(VBoxManage showvminfo --machinereadable $cluster_base | grep -q ^VMState=.poweroff.); do
		sleep 1
	done

	# Export the base image
	VBoxManage export $cluster_base -o $chef_cluster_base_dir/$cluster_base.ova
	
}

vbox_network_create () {
	# Create the host-only network
	VBoxManage hostonlyif --dhcp create $hostonlyif
	VBoxManage dhcpserver add --ip $networkip --netmask $netmask --lowerip $lowerip --upperip $upperip --enable
}

chef_server_create () {
	# Import the cluster base image for the chef server and nodes, add a shared folder containing server setup scripts, and configure the servers
	VBoxManage import $chef_cluster_base_dir/$cluster_base.ova --vsys 0 --vmname "Chef Server Centos"
	VBoxManage sharedfolder add "Chef Server Centos" --name "chef_setup_scripts" --hostpath $vbox_share --transient --automount
	VBoxManage startvm "Chef Server Centos" --type headless
	# Wait fot the vm to finish powering on
	until $(VBoxManage showvminfo --machinereadable "Chef Server Centos" | grep -q ^VMState=.running.); do
		sleep 1
	done
	VBoxManage guestcontrol "Chef Server Centos" execute --image /media/sf_chef_setup_scripts/get_dhcp_ips.sh --username root --password testroot --wait-exit -- master/$chef_server
}

chef_node_create () {
	node_name=ChefNode$1
	echo "#!/bin/bash" >> $vbox_share/chef_node_name.sh
	echo "export node_name=$node_name" > $vbox_share/chef_node_name.sh
	VBoxManage import $chef_cluster_base_dir/$cluster_base.ova --vsys 0 --vmname $node_name
	VBoxManage sharedfolder add $node_name --name "chef_setup_scripts" --hostpath $vbox_share --transient --automount
	VBoxManage startvm $node_name --type headless
	# Wait fot the vm to finish powering on
	until $(VBoxManage showvminfo --machinereadable $node_name | grep -q ^VMState=.running.); do
		sleep 1
	done
	VBoxManage guestcontrol $node_name execute --image /media/sf_chef_setup_scripts/get_dhcp_ips.sh --username root --password testroot --wait-exit -- node/$node_name
}

configure_cluster() {
	# Configure kubernetes and chef on all VMs, and export each for later cloning
 
	# Modify the kubernetes config files
	## /etc/kubernetes/config
	tmp=$(mktemp)
	cat $vbox_share/kubernetes/templates/config >> $tmp
	sed -i 's/KUBE_ETCD_SERVERS=/&http://'"$chef_server"':4001/' $tmp
	cp $tmp $vbox_share/kubernetes

	## /etc/kubernetes/apiserver
	cat $vbox_share/kubernetes/templates/apiserver >> $tmp
	sed -i 's/KUBE_MASTER=/&http://'"$chef_server"':8080' $tmp
	cp $tmp $vbox_share/kubernetes

	## /etc/kubernetes/controller-manager
	nodes=""
	count=0
	for f in $(ls host_files/nodes); do
		if [[ $count == 0 ]]; then
			nodes=$f
		else
			nodes=$(echo "$nodes,$f")
		fi
		(( count+=1 ))
	done
	
	cat $vbox_share/kubernetes/templates/controller-manager >> $tmp
	sed -i 's/KUBELET_ADDRESSES=/&\"--machines='"$nodes"'/' $tmp
	cp $tmp $vbox_share/kubernetes

	rm $tmp

	# Configure the chef server
	VBoxManage guestcontrol "Chef Server Centos" execute --image /media/sf_chef_setup_scripts/chef_server_setup.sh --wait-exit
	machines="Chef Server Centos"

	# Configure the chef nodes
	for f in $(ls host_files/nodes); do
		VBoxManage guestcontrol $f execute --image /media/sf_chef_setup_scripts/chef_node_setup.sh --wait-exit
		machines=$(echo "$machines $f")
	done
	
	# Export the cluster as a single appliance for cloning
	VBoxManage export $machines -o $chef_cluster_base_dir/$Chef_Cluster.ova
}


# If VirtualBox isn't installed, tell the user to install it
#verify_virtualbox

# If Apache isn't installed, tell the user to install it, and then instruct them to point the doc root to the appropriate files

#verify_apache

# Setup the environment

source vbox_env.sh

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

# Ask the user if they want to create a new chef cluster
read -p "Would you like to create a new chef cluster? [Y/N] " yn

while true; do
	case $yn in
		Y|y)
			chef_server_create
			read -p "How many chef nodes would you like to create? " node_num
			# NOTE: also need to check whether node_num is a number!
			while true; do
				if [[ -z "$node_num" ]]; then
					read -p "Please enter a number of nodes greater or equal to zero: " node_num
				else
					count=0

					while [[ $count < $node_num ]]; do
						chef_node_create $node_num
						((count += 1))
					done
					break
				fi
			done
			configure_cluster
			break;;
		N|n)
			break;;
		*)
	esac
done

echo "Chef cluster creation was successful!"









