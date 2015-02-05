#!/bin/bash

# Usage:  chef-workstation [chef repo location]
# The purpose of this script is to completely set up a workstation on a linux workstation.  The same steps will be outlined for Mac and Windows in another document.

# Install Chef DK

 
# Clone the repo into the location provided
cd $1
git clone https://github.com/cancerregulome/docker-prototyping.git

echo "export CHEF_REPO=$1/docker-prototyping/chef-repo" >> $HOME/.bashrc
source .bashrc

cd $CHEF_REPO

# Configure knife and .chef directory
mkdir .chef
cd .chef
scp -o stricthostkeychecking=no chef@chef-server:/home/chef/admin.pem .
scp -o stricthostkeychecking=no chef@chef-server:/home/chef/isb-validator.pem .
knife configure --admin-client-name admin --admin-client-key $CHEF_REPO/.chef/admin.pem -r $CHEF_REPO --validation-client-name isb-validator --validation-client-key $CHEF_REPO/.chef/isb-validator.pem
knife ssl fetch

# Update the .pem files in the dockerfile contexts


# Download additional archive files for software installations
