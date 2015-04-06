# zookeeper::default.rb

# Update the number of configured zookeepers
# This will likely need to be moved somewhere more globally whenever autoscaling code is written
node.default[:zookeeper][:configured_zookeepers] += 1

# Install the necessary packages
package "openjdk-7-jdk"
package "openjdk-7-jre"

cookbook_file "install/zookeeper-3.4.6.tar.gz" do
	path "/usr/local/src/zookeeper-3.4.6.tar.gz"
end

execute "tar -xf /usr/local/src/zookeeper-3.4.6.tar.gz && mv /usr/local/src/zookeeper-3.4.6 /usr/local"

# Configure zookeeper
file "/var/zookeeper/myid" do
	content "#{node[:zookeeper][:configured_zookeepers]}"
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








