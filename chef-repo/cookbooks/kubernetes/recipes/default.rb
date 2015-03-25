#
# Cookbook Name:: kubernetes
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install gems and other dependencies

# NOTE:  the following packages, when installed manually, allow the chef provisioning gem to be installed fine.

yum_package "ruby-devel" do
	action :install
end

yum_package "epel-release" do 
	action :install
end

yum_package "patch" do 
	action :install
end


chef_gem "chef-provisioning-docker" do
	action :install
end

