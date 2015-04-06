#
# Cookbook Name:: pods
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

require 'chef/provisioning/docker_driver'

machine_image "zookeeper-#{node[:pods][:zookeeper][:version]}" do
	recipe 'zookeeper'
	
	machine_options :docker_options => {
		:base_image => {
			:name => 'ubuntu',
			:repository => 'ubuntu',
			:tag => '14.04'
		}
	}
	
	:env => {
		"ZOOKEEPER_HOME" => node[:pods][:zookeeper][:environment][:zookeeper_home]
	}
	
	#:command => "java -cp $ZOOKEEPER_HOME/zookeeper-3.4.6.jar:$ZOOKEEPER_HOME/lib/slf4j-api-1.6.1.jar:$ZOOKEEPER_HOME/lib/slf4j-log4j12-1.6.1.jar:$ZOOKEEPER_HOME/lib/log4j-1.2.15.jar:conf \ org.apache.zookeeper.server.quorum.QuorumPeerMain $ZOOKEEPER_HOME/conf/zoo.cfg" 
	:ports => node[:pods][:zookeeper][:ports]
end
