# Usage:  chef-server-setup.sh hostname fqdn

hostname=%1
fqdn=%2

apt-get update
apt-get install build-essential
wget https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.0.1-1_amd64.deb
dpkg -i chef-server-core_12.0.1-1_amd64.deb
apt-get clean





