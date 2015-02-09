# Usage:  chef-server-setup.sh hostname fqdn user fullname email pass orgshort orglong

hostname=%1
fqdn=%2

apt-get update
apt-get install build-essential
wget https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.0.1-1_amd64.deb
dpkg -i chef-server-core_12.0.1-1_amd64.deb
apt-get clean

chef-server-ctl user-create $user $fullname $email $pass --filename ~/$user.pem
chef-server-ctl org-create $orgshort $orglong --association-user $user --filename ~/$orgshort-validator.pem
chef-server-ctl reconfigure
exit





