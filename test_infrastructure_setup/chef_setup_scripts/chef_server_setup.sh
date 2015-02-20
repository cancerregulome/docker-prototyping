# Install necessary packages
apt-get update
apt-get install build-essential
wget https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.0.1-1_amd64.deb
dpkg -i chef-server-core_12.0.1-1_amd64.deb
apt-get clean

# Set up the environment
source chef_server_env.sh

# Configure the chef server
chef-server-ctl user-create $user $fullname $email $pass --filename ~/$user.pem
chef-server-ctl org-create $orgshort $orglong --association-user $user --filename ~/$orgshort-validator.pem
chef-server-ctl reconfigure

# Update networking details
## Modify /etc/sysconfig/network
sed -i 's/HOSTNAME=/&'"$chef_server"'.com/' /etc/sysconfig/network

## Modify /etc/hosts
sed -i 's/127.0.0.1\t/&'"$chef_server"'/' /etc/hosts

## Write to a dummy hosts file in the VM shared directory so that other VMs can see the DHCP generated IP of the chef server
ifcfg_eth1=$(ifconfig | awk 'BEGIN { RS = ""; FS = "\n";} /eth1/ {print $2}' | awk '{print $2}' | awk 'BEGIN { FS=":";} {print $2}')
echo "$ifcfg_eth1	$chef_server.com $chef_server" >> $vbox_share/host_files/chef_server

# Poweroff
poweroff





