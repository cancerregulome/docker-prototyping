#
# Cookbook Name:: pod_manager
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Create the pod configuration directory for zookeeper
directory "/etc/kubernetes/pods/zookeeper" do
	mode '0400'
	owner 'root'
	group 'root'
	action :create
	recursive true
end