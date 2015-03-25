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

case node[:platform]
when "centos", "redhat"
	yum_package "ruby-devel"

	yum_package "epel-release" 

	yum_package "patch" 
end

chef_gem "chef-provisioning-docker" do
	action :install
end

