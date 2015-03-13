#!/bin/bash

## Write to a dummy hosts file in the VM shared directory so that other VMs can see the DHCP generated IP of the chef server
ifcfg_eth1=$(ifconfig | awk 'BEGIN { RS = ""; FS = "\n";} /eth1/ {print $2}' | awk '{print $2}' | awk 'BEGIN { FS=":";} {print $2}')
echo "$ifcfg_eth1	$1.com $1" >> $vbox_share/host_files/$1
