#
# Cookbook Name:: kubernetes
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install gems and other dependencies

# NOTE:  Only install the patch command if it's not there already
yum_package "ruby-devel" do
	action :install
end

yum_package "epel-release" do 
	action :install
end

chef_gem "chef-provisioning-docker" do
	action :install
end



