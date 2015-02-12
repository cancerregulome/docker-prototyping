#!/bin/bash

# Create the network
VBoxManage natnetwork add --netname NatNetwork1 --enable --dhcp on
VBoxManage hostonlyif --dhcp create vboxnet0 
VBoxManage dhcpserver add --ip 192.168.56.100 --netmask 255.255.255.0 --lowerip 192.168.56.101 --upperip 192.168.56.254 --enable
