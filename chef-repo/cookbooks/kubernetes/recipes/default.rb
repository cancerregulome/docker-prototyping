#
# Cookbook Name:: kubernetes
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Create the repo from a cookbook file

case node[:platform]
when "centos", "redhat"
	cookbook_file "virt7-testing.repo" do
		path "/etc/yum.repos.d/virt7-testing.repo"
		mode 00644
	end

	yum_package 'kubernetes' do
		action :install
		flush_cache [:before]
		options "--enablerepo=virt7-testing"
	end
end

# Try using the docker cookbook to update the docker installation for chef 
include_recipe "docker"



