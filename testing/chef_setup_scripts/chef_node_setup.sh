#!/bin/bash

# Install necessary packages (Kubernetes)
yum -y update
yum -y install --enablerepo=updates-testing kubernetes
yum -y clean

# Set up the environment
source chef_node_name.sh

# Update networking details
## Modify /etc/sysconfig/network
sed -i 's/HOSTNAME=/&'"$node_name"'.com/' /etc/sysconfig/network

## Modify /etc/hosts for chef
sed -i 's/127.0.0.1\t/&'"$node_name"'/' /etc/hosts

cat host_files/master/* > /etc/hosts
for f in $(ls host_files/nodes); do
	if [ "$f" != "$node_name" ]; then
		cat $f > /etc/hosts
	fi
done

# Put the kubernetes config files in the correct locations
cp /media/sf_chef_setup_scripts/kubernetes/config /etc/kubernetes
cp /media/sf_chef_setup_scripts/kubernetes/kubelet /etc/kubernetes

# Restart services
for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler network; do
	systemctl restart $SERVICES
	systemctl enable $SERVICES
done

# Poweroff
poweroff

