#!/bin/bash

# For MacOSX and Linux systems

# The host (:port, optional) of the machine that will be serving the boot files over the network
export tftp_host=lime.systemsbiology.net:8888

# The apache server root for the machine serving the boot files
export apache_doc_root=/Applications/MAMP/htdocs

# The location of the centos6 base image
export centos6_iso=/Users/ahahn/Desktop/Stuff/CentOS-6.6-x86_64-minimal.iso

# The location of the centos7 base image
export centos7_iso=/Users/ahahn/Desktop/Stuff/CentOS-7.0-1406-x86_64-Minimal.iso

# The directory where VirtualBox stores vms, by default
export vbox_vm_dir=/Users/ahahn/"VirtualBox VMs"

# The VirtualBox TFTP directory (you probably won't need to change this)
export vbox_tftp_dir=/Users/ahahn/Library/VirtualBox/TFTP

# The test infrastructure setup root directory (i.e., the absolute path to the location on your local machine where you have copied the test_infrastructure_setup directory)
export setup_dir=/Users/ahahn/Desktop/VM_Share/testing

# The directory functioning as a shared volume between VMs and the host 
export vbox_share=$setup_dir/kubernetes_setup

# Location of the Linux Guest Additions iso file
export guest_additions=/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso

# The location of the kube cluster base images to clone from
export cluster_dir=/Users/ahahn/Desktop/VM_Cluster

# Network details

#export hostonlyif=

#export networkip=

#export netmask=

#export lowerip=

#export upperip=




