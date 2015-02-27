#!/bin/bash -e

#verify_virtualbox () {
	# Determine if the correct version of VirtualBox is installed
	
#}

#verify_apache () {
	# Change to verify_apache
	# ping webserver on expected port
#}

pxeboot_setup() {
	# Create the necessary directories and bootfiles
	vm_name=$1
	OS=$2
	
	if [[ ! -d $vbox_tftp_dir/images/$OS ]]; then
		mkdir -p $vbox_tftp_dir/images/$OS
	fi

	if [[ ! -d $vbox_tftp_dir/pxelinux.cfg ]]; then
		mkdir -p $vbox_tftp_dir/pxelinux.cfg
	fi

	cp $setup_dir/boot_files/$OS/initrd.img  $setup_dir/boot_files/$OS/vmlinuz $vbox_tftp_dir/images/$OS
	
	cp $setup_dir/boot_files/$OS/pxelinux.0 $vbox_tftp_dir/$vm_name.pxe
	
	# Set up the directory for exported base images
	if [[ ! -d $cluster_dir ]]; then 
		mkdir -p $cluster_dir
	fi

}

vm_create () {
	vm_name=$1
	OS=$2
	
	pxeboot_setup $vm_name $OS

	if [[ $OS == "centos6" ]]; then
		iso=$centos6_iso
		append_string="APPEND initrd=images/$OS/initrd.img ks=http://$tftp_host/$vm_name-ks.cfg ksdevice=eth0"
	elif [[ $OS == "centos7" ]]; then
		iso=$centos7_iso
		append_string="APPEND initrd=images/$OS/initrd.img inst.repo=cdrom:LABEL=CentOS_7_x86_64 inst.ks=http://$tftp_host/$vm_name-ks.cfg"
	fi
	
	# Create the centos7 base vm
	VBoxManage createvm --name $vm_name --ostype "RedHat_64" --register 
	## Add network interfaces and memory, and enable ACPI
	VBoxManage modifyvm $vm_name --memory 2048 --vram 12 --acpi on
	VBoxManage modifyvm $vm_name --nic1 nat --nic2 hostonly --hostonlyadapter2 vboxnet0
	## Configure TFTP
	VBoxManage modifyvm $vm_name --nattftpprefix1 $vbox_tftp_dir --natdnshostresolver1 on
	## Create a hard drive
	VBoxManage createhd --filename $vm_name.vdi --size 20000
	## Create and attach storage devices (CentOS and Guest Additions images)
	VBoxManage storagectl $vm_name --name IDE --add ide
	VBoxManage storageattach $vm_name --storagectl IDE --port 0 --device 0 --type dvddrive --medium $iso
	#VBoxManage storageattach $vm_name --storagectl IDE --port 1 --device 1 --type dvddrive --medium $guest_additions
	VBoxManage storagectl $vm_name --name SATA --add sata  
	VBoxManage storageattach $vm_name --storagectl SATA --port 0 --device 0 --type hdd --medium $vm_name.vdi
	## Modify the boot order
	VBoxManage modifyvm $vm_name --boot1 disk --boot2 net --boot3 none --boot4 none
	
	# Get and format the mac addresses of the network interfaces
	eth0=$(VBoxManage showvminfo --machinereadable $vm_name | grep macaddress1 | awk 'BEGIN { FS="="; } {print $2}' | awk 'BEGIN {FS="\"";} {print $2}' | sed 's/.\{2\}/&:/' | sed 's/.\{5\}/&:/' | sed 's/.\{8\}/&:/' | sed 's/.\{11\}/&:/' | sed 's/.\{14\}/&:/')
	eth1=$(VBoxManage showvminfo --machinereadable $vm_name | grep macaddress2 | awk 'BEGIN { FS="="; } {print $2}' | awk 'BEGIN {FS="\"";} {print $2}' | sed 's/.\{2\}/&:/' | sed 's/.\{5\}/&:/' | sed 's/.\{8\}/&:/' | sed 's/.\{11\}/&:/' | sed 's/.\{14\}/&:/')

	echo "DEFAULT centos7" > $vbox_tftp_dir/pxelinux.cfg/default
	echo "LABEL centos7" >> $vbox_tftp_dir/pxelinux.cfg/default
	echo "KERNEL images/$OS/vmlinuz" >> $vbox_tftp_dir/pxelinux.cfg/default
	echo $append_string >> $vbox_tftp_dir/pxelinux.cfg/default
	#echo "APPEND initrd=images/CentOS/x86_64/7/initrd.img inst.ks=http://$tftp_host/anaconda-ks.cfg" >> $vbox_tftp_dir/pxelinux.cfg/default
	# for reference:  eth0=>enp0s3  eth1=>enp0s8
	# Copy the necessary files to the apache document root
	cp -R $setup_dir/boot_files/$OS/$vm_name-ks.cfg $apache_doc_root
	
	# Start the VM
	VBoxManage startvm $vm_name #--type headless
	
	# Wait fot the installation to finish
	until $(VBoxManage showvminfo --machinereadable $vm_name | grep -q ^VMState=.poweroff.); do
		sleep 1
	done

	# Export the base image
	#VBoxManage export $vm_name -o $kube_cluster_dir/$vm_name.ova
	
}

vbox_network_create () {
	# Create the host-only network
	VBoxManage hostonlyif --dhcp create $hostonlyif
	VBoxManage dhcpserver add --ip $networkip --netmask $netmask --lowerip $lowerip --upperip $upperip --enable
}

kube_master_config () {
	vm_name="kube-master"
	# Import the cluster base image for the kube server and nodes, add a shared folder containing server setup scripts, and configure the servers
	VBoxManage import $kube_cluster_dir/$vm_name.ova --vsys 0 --vmname $vm_name
	VBoxManage sharedfolder add $vm_name --name "kubernetes_setup" --hostpath $vbox_share --transient --automount
	VBoxManage startvm $vm_name --type headless
	# Wait fot the vm to finish powering on
	until $(VBoxManage showvminfo --machinereadable $vm_name | grep -q ^VMState=.running.); do
		sleep 1
	done
	VBoxManage guestcontrol $vm_name execute --image /media/sf_kubernetes_setup/get_dhcp_ips.sh --username root --password testroot --wait-exit -- $vm_name host_files/master/$vm_name
}

kube_minion_config () {
	node_num=$1
	vm_name="kube-minion"$node_num
	VBoxManage import $kube_cluster_dir/$vm_name.ova --vsys 0 --vmname $vm_name
	VBoxManage sharedfolder add $vm_name --name "kubernetes_setup" --hostpath $vbox_share --transient --automount
	VBoxManage startvm $vm_name --type headless
	# Wait fot the vm to finish powering on
	until $(VBoxManage showvminfo --machinereadable $vm_name | grep -q ^VMState=.running.); do
		sleep 1
	done
	VBoxManage guestcontrol $vm_name execute --image /media/sf_kubernetes_setup/get_dhcp_ips.sh --username root --password testroot --wait-exit -- $vm_name host_files/minions/$vm_name
}

kube_cluster_config() {
	# Configure kubernetes and kube on all VMs, and export each for later cloning
	tmp=$(mktemp) 	

	# Modify the kubernetes config files
	## /etc/kubernetes/config
	cat $vbox_share/kube.conf/templates/config >> $tmp
	sed -i 's/KUBE_ETCD_SERVERS=/&http://kube-master:4001/' $tmp
	cp $tmp $vbox_share/kube.conf

	## /etc/kubernetes/apiserver
	cat $vbox_share/kube.conf/templates/apiserver >> $tmp
	sed -i 's/KUBE_MASTER=/&http://kube-master:8080' $tmp
	cp $tmp $vbox_share/kube.conf

	## /etc/kubernetes/controller-manager
	nodes=""
	count=0
	for f in $(ls host_files/minions); do
		if [[ $count == 0 ]]; then
			nodes=$f
		else
			nodes=$(echo "$nodes,$f")
		fi
		(( count+=1 ))
	done
	
	cat $vbox_share/kube.conf/templates/controller-manager >> $tmp
	sed -i 's/KUBELET_ADDRESSES=/&\"--machines='"$nodes"'/' $tmp
	cp $tmp $vbox_share/kube.conf

	rm $tmp

	# Configure the kube master
	VBoxManage guestcontrol kube-master execute --image /media/sf_kubernetes_setup/kube_master_setup.sh --wait-exit
	
	machines="kube-master"

	# Configure the kube nodes
	for f in $(ls host_files/minions/kube-minion*); do
		VBoxManage guestcontrol $f execute --image /media/sf_kube_setup_scripts/kube_minion_setup.sh --wait-exit -- $f
		machines=$(echo "$machines $f")
	done
	
	# Export the cluster as a single appliance for cloning
	VBoxManage export $machines -o $kube_cluster_dir/Kube_Cluster.ova
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

# Ask the user if they want to create a new kube cluster
read -p "Would you like to create a new cluster? [Y/N] " yn

while true; do
	case $yn in
		Y|y)
			read -p "Enter a vm name: " vm_name
			echo "Choose an OS for $vm_name: "
			echo "	[1] CentOS6.6"
			echo "	[2] CentOS7"
			read -p "Enter a number: " num
			if [[ $num == 1 ]]; then
				OS="centos6"
			else
				OS="centos7"
			fi
			vm_create $vm_name $OS
			break;;
			#read -p "Would you like to create another vm for the cluster? [Y/N] " yn
		N|n)
			break;;
		*)
	esac
done

echo "Cluster creation was successful!"









