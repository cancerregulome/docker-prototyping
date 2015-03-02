#!/bin/bash

node_name=$1

# Update networking details
## Modify /etc/sysconfig/network
sed -i 's/HOSTNAME=/&'"$node_name"'.com/' /etc/sysconfig/network

## Modify /etc/hosts for chef
sed -i 's/127.0.0.1\t/&'"$node_name"'/' /etc/hosts

cat host_files/master/* > /etc/hosts
for f in $(ls host_files/minions); do
	if [ "$f" != "$node_name" ]; then
		cat $f > /etc/hosts
	fi
done

# Put the kubernetes config files in the correct locations
cp /media/sf_kubernetes_setup/kube.conf/config /etc/kubernetes
cp /media/sf_kubernetes_setup/kube.conf/kubelet /etc/kubernetes

# Put the dockerfiles in the correct registry directory
cp /media/sf_kubernetes_setup/dockerfiles/* /var/docker-registry

# Restart services
for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler network; do
	systemctl restart $SERVICES
	systemctl enable $SERVICES
	systemctl status $SERVICES
done

# Poweroff
poweroff

