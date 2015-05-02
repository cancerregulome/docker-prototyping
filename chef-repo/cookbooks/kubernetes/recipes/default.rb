#
# Cookbook Name:: kubernetes
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "yum_update" do
	command "yum -y update"
	action :run
end

# Create the repo from a cookbook file

case node[:platform]
when "centos", "redhat"
	cookbook_file "virt7-testing.repo" do
		path "/etc/yum.repos.d/virt7-testing.repo"
		mode 0644
	end
	
	execute "erase_etcd" do
		command "yum -y erase etcd && yum -y install http://cbs.centos.org/kojifiles/packages/etcd/0.4.6/7.el7.centos/x86_64/etcd-0.4.6-7.el7.centos.x86_64.rpm"
		not_if "etcd --version | grep 0.4.6"
	end

	yum_package 'kubernetes' do
		action :install
		flush_cache [:before]
		options "--enablerepo=virt7-testing"
	end
end

# Try using the docker cookbook to update the docker installation for chef 
include_recipe "docker"



