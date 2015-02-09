#
# Cookbook Name:: solrcloud
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install necessary packages

node_num = node.default['node_id']

package "epel-release" do
	action :install
end

package "docker-io" do
	action :install
end

execute "yum -y update && yum -y clean all"

# Install additional cookbook files from Chef Server (docker contexts and installation files for solr, tomcat and zookeeper)

remote_directory "/dockerfiles" do
	source "dockerfiles"
	action :create
end

# Create a file containing the node number that was passed in through the command line using knife.  This will be the zookeeper container's ID within the ensemble.
file "/dockerfiles/zookeeper/config/myid" do
	content "#{node_num}"
	action :create
end

service "docker" do
	action :start
end






