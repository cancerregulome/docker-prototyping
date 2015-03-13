#!/bin/bash

# Update networking details
## Modify /etc/sysconfig/network
sed -i 's/HOSTNAME=/&kube-master.com/' /etc/sysconfig/network

## Modify /etc/hosts for chef and kubernetes
sed -i 's/127.0.0.1\t/&kube-master.com kube-master/' /etc/hosts

cat host_files/nodes/* >> /etc/hosts

# Put the config files in the correct places
cp /media/sf_kubernetes_setup/kube.conf/config /etc/kubernetes
cp /media/sf_kubernetes_setup/kube.conf/apiserver /etc/kubernetes
cp /media/sf_kubernetes_setup/kube.conf/controller-manager /etc/kubernetes

# Start/restart services
for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler network; do
	systemctl restart $SERVICES
	systemctl enable $SERVICES
	systemctl status $SERVICES
done

# Poweroff
poweroff





