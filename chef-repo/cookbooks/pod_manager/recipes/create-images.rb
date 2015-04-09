require "chef/provisioning/docker_driver"
# Get data bag items
registry_users = data_bag_item("nginx_proxy_auth", "docker_registry_users")
registry_admin = registry_users["admin_user"]
registry_admin_password = registry_users["users"][registry_admin]["password"]
registry_admin_email = registry_users["users"][registry_admin]["email"]

# Set up the environment

ENV['CHEF_DRIVER'] = node[:kubernetes][:env][:chef_driver]

# Create the machine images

machine_image "zookeeper" do
	recipe 'zookeeper'

	machine_options :docker_options => {
		:base_image => {
			:name => 'ubuntu',
			:repository => 'ubuntu',
			:tag => '14.04'
		},
		:command => "java -cp $ZOOKEEPER_HOME/zookeeper-3.4.6.jar:$ZOOKEEPER_HOME/lib/slf4j-api-1.6.1.jar:$ZOOKEEPER_HOME/lib/slf4j-log4j12-1.6.1.jar:$ZOOKEEPER_HOME/lib/log4j-1.2.15.jar:conf \ org.apache.zookeeper.server.quorum.QuorumPeerMain $ZOOKEEPER_HOME/conf/zoo.cfg"
	}
end	

# Log in to the private docker registry
#docker_registry "localhost:5000" do
#	username "#{registry_admin}"
#	password "#{registry_admin_password}"
#	email "#{registry_admin_email}"
#end

# Tag the images for pushing to the local registry
#docker_image "zookeeper-#{node[:pods][:zookeeper][:version]}" do
#	repository "localhost:5000/zookeeper-#{node[:pods][:zookeeper][:version]}"
#	tag 'latest'
#	action :commit
#end

# Push images to private registry
#docker_image "zookeeper-#{node[:pods][:zookeeper][:version]}:latest" do
#	action :push
#end

	


