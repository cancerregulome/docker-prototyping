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
# NOTE:  need to find a way to check OS before deciding to install using yum

execute "yum_update" do
	command "yum -y update"
	action :run
end

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

gem_package "chef-provisioning" do
	#compile_time false if respond_to?(:compile_time)
	action :install
end

gem_package "chef-provisioning-docker" do
	#compile_time false if respond_to?(:compile_time)
	action :install
end

