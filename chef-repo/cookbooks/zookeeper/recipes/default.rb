# zookeeper::default.rb

# Install the necessary packages
package "openjdk-7-jdk"
package "openjdk-7-jre"

cookbook_file "install/zookeeper-3.4.6.tar.gz" do
	path "/usr/local/src/zookeeper-3.4.6.tar.gz"
end

execute "tar -xf /usr/local/src/zookeeper-3.4.6.tar.gz && mv /usr/local/src/zookeeper-3.4.6 /usr/local"

# Configure zookeeper
file "/var/zookeeper/myid" do
	content "#{ENV['ZOOKEEPERS']}"
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






