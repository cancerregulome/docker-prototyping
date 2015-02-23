# Install necessary packages (Chef, Kubernetes)
yum -y update
yum -y install --enablerepo=updates-testing kubernetes
wget https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.0.1-1_amd64.deb
dpkg -i chef-server-core_12.0.1-1_amd64.deb
yum -y clean

# Set up the environment
source chef_server_env.sh

# Update networking details
## Modify /etc/sysconfig/network
sed -i 's/HOSTNAME=/&'"$chef_server"'.com/' /etc/sysconfig/network

## Modify /etc/hosts for chef and kubernetes
sed -i 's/127.0.0.1\t/&'"$chef_server.com $chef_server"'/' /etc/hosts

cat host_files/nodes/* > /etc/hosts

# Put the config files in the correct places
cp /media/sf_chef_setup_scripts/kubernetes/config /etc/kubernetes
cp /media/sf_chef_setup_scripts/kubernetes/apiserver /etc/kubernetes
cp /media/sf_chef_setup_scripts/kubernetes/controller-manager /etc/kubernetes

# Start/restart services
for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler network; do
	systemctl restart $SERVICES
	systemctl enable $SERVICES
done

# Configure the chef server
chef-server-ctl user-create $user $fullname $email $pass --filename ~/$user.pem
chef-server-ctl org-create $orgshort $orglong --association-user $user --filename ~/$orgshort-validator.pem
chef-server-ctl reconfigure

# Poweroff
poweroff





