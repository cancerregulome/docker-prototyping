#!/bin/bash

# Cygwin variables
export C=/cygdrive/c
export home_dir=/cygdrive/c/Users/Abby

# For MacOSX and Linux systems

# The ipaddress of the machine that will be serving the boot files over the network
export host_ip=192.168.76.2

# The apache server root for the machine serving the boot files
#export apache_root=

# The directory where all of your ISO files live
export iso_dir=$home_dir/Desktop/ISB

# The name of the .ova image file to import
export cluster_base=Cluster_Base

# The directory where VirtualBox stores vms, by default
export vbox_vm_dir=$home_dir"/VirtualBox VMs/"

# The VirtualBox TFTP directory (you probably won't need to change this)
export vbox_tftp_dir=$home_dir/.VirtualBox/TFTP

# The test infrastructure setup root directory (i.e., the absolute path to the location on your local machine where you have copied the test_infrastructure_setup directory)
export setup_dir=$home_dir/Desktop/ISB/test_infrastructure_setup

# The directory functioning as a shared volume between VMs and the host 
export vbox_share=$home_dir/$setup_dir/setup_scripts/linux

# Location of the Linux Guest Additions iso file
export guest_additions=$C/"Program Files"/Oracle/VirtualBox/VBoxGuestAdditions.iso

# Network details
#export natnetwork=

#export hostonlyif=

#export networkip=

#export netmask=

#export lowerip=

#export upperip=




