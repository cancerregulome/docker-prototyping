#
# Cookbook Name:: pod_manager
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

yum_package "gcc" do
	action :install
end

yum_package "ruby-devel" do
	action :install
end

yum_package "zlib-devel" do
	action :install
end

yum_package "epel-release" do 
	action :install
end

yum_package "patch" do 
	action :install
end

chef_gem "chef-provisioning-docker" do
	compile_time false if respond_to?(:compile_time)
	action :install
end