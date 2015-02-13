#!/bin/bash

# First, add the MAC address to ifcfg-ethX files
echo "HWADDR=$1" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "HWADDR=$1" >> /etc/sysconfig/network-scripts/ifcfg-eth1

# Modify /etc/hosts
sed -i 's/127.0.0.1	localhost/127.0.0.1	$fqdn $hostname localhost/' /etc/hosts

# Restart network service
service network restart
