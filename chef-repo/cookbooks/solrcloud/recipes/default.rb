#
# Cookbook Name:: solrcloud
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install necessary packages

execute "yum -y update && yum -y install epel-release docker-io && yum clean all"

# Install additional cookbook files from Chef Server (docker contexts and installation files for solr, tomcat and zookeeper)

remote_directory "/dockerfiles" do
	source "dockerfiles"
	action :create
end

# Create a file containing the node number that was passed in through the command line using knife.  This will be the zookeeper container's ID within the ensemble.
file "/dockerfiles/zookeeper/config/myid" do
	content "#{node['node_id']}"
	action :create
end

service "docker" do
	action :start
end






