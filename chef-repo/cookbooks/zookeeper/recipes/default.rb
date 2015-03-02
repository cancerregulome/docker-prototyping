# zookeeper::default.rb

# Install the necessary packages
package "openjdk-7-jdk"
package "openjdk-7-jre"

cookbook_file "install/zookeeper-3.4.6.tar.gz" do
	path "/usr/local/src/zookeeper-3.4.6.tar.gz"
end

execute "tar -xf /usr/local/src/zookeeper-3.4.6.tar.gz && mv /usr/local/src/zookeeper-3.4.6 /usr/local"

# Configure zookeeper
template "/var/zookeeper/myid" do
	source "?" # figure this out later
end

template "/usr/local/zookeeper-3.4.6/conf/zoo.cfg" do
	source "zoo.cfg.erb"
end




