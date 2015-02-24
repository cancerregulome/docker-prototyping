#!/bin/bash

# For MacOSX and Linux systems

# The host (:port, optional) of the machine that will be serving the boot files over the network
export tftp_host=lime.systemsbiology.net:8888

# The apache server root for the machine serving the boot files
export apache_doc_root=/Applications/MAMP/htdocs

# The directory where all of your ISO files live
export iso_dir=/Users/ahahn/Desktop/Stuff

# The name of the .ova image file to import
export cluster_base=ClusterBase

# The directory where VirtualBox stores vms, by default
export vbox_vm_dir=/Users/ahahn/"VirtualBox VMs"

# The VirtualBox TFTP directory (you probably won't need to change this)
export vbox_tftp_dir=/Users/ahahn/Library/VirtualBox/TFTP

# The test infrastructure setup root directory (i.e., the absolute path to the location on your local machine where you have copied the test_infrastructure_setup directory)
export setup_dir=/Users/ahahn/Desktop/VM_Share/testing

# The directory functioning as a shared volume between VMs and the host 
export vbox_share=$setup_dir/chef_setup_scripts

# Location of the Linux Guest Additions iso file
export guest_additions=/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso

# The location of the chef cluster base images to clone from
export chef_cluster_dir=/Users/ahahn/Desktop/Chef_Cluster

# The chef server hostname to use
export chef_server=chef-server

# Network details

#export hostonlyif=

#export networkip=

#export netmask=

#export lowerip=

#export upperip=




