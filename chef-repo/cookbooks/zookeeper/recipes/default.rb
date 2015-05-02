# zookeeper::default.rb
require 'chef/run_lock'
require 'chef/file_cache'

# Install the necessary packages
package "openjdk-7-jdk"
package "openjdk-7-jre"

cookbook_file "install/zookeeper-3.4.6.tar.gz" do
	path "/usr/local/src/zookeeper-3.4.6.tar.gz"
	not_if "ls /usr/local/src | grep zookeeper-3.4.6.tar.gz"
end

execute "install_zookeeper" do
	command "tar -xf /usr/local/src/zookeeper-3.4.6.tar.gz && mv /usr/local/src/zookeeper-3.4.6 /usr/local"
	not_if "ls /usr/local | grep zookeeper-3.4.6"
end

# Create a lock for accessing a databag item
lock = Chef::RunLock.new(Chef::FileCache.find("chef-client-running.pid"))

# Grab the lock and update the current number of configured zookeepers and hostnames
lock.aquire()
cluster_info = data_bag_item("clusters", "solr-cluster")
zookeeper_id = cluster_info["nodes"]["zookeeper"]["active_nodes"] + 1
hosts = cluster_info["nodes"]["zookeeper"]["hosts"].add(ENV["HOSTNAME"])
cluster_info["nodes"]["zookeeper"]["active_nodes"] = zookeeper_id
cluster_info["nodes"]["zookeeper"]["hosts"] = hosts
cluster_info.save()

# Release the lock
lock.release()

# Configure zookeeper
file "/var/zookeeper/myid" do
	content "#{zookeeper_id}"
	action :create
end

template "/usr/local/zookeeper-3.4.6/conf/zoo.cfg" do
	source "zoo.cfg.erb"
	variables({
		:tick_time => node[:zookeeper][:tick_time],
		:data_dir => node[:zookeeper][:data_dir],
		:client_port => node[:zookeeper][:ports][:client_port],
		:init_limit => node[:zookeeper][:init_limit],
		:sync_limit => node[:zookeeper][:sync_limit],
		:servers => node[:zookeeper][:servers]
	})
end








