#
# Cookbook Name:: kubernetes
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install gems and other dependencies

package "patch" do
	action :install
end

chef_gem "chef-provisioning-docker" do
	action :install
end



