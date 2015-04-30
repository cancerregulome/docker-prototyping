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
		mode 00644
	end

	yum_package 'kubernetes' do
		action :install
		flush_cache [:before]
		options "--enablerepo=virt7-testing"
	end
end

# Install gcloud tool
#execute 'install_gcloud' do
#	command "curl https://sdk.cloud.google.com | bash"
#	not_if ::Dir.exists?('/google-cloud-sdk')
#end

# Try using the docker cookbook to update the docker installation for chef 
include_recipe "docker"



