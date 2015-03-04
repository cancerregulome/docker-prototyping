# Upload the chef configuration directory for zookeeper
remote_directory "/zookeeper" do
	#files_mode
	#files_owner
	#mode
	#owner
	#group
	path "/etc/kubernetes/pods/zookeeper"
end

# Create the zookeeper controller file
template "/etc/kubernetes/pods/zookeeper/zookeeper-controller.json" do
	source "zookeeper-controller.erb"
	#mode
	#owner
	#group
	variables({
		:version => node[:pods][:zookeeper][:version],
		:client_port => node[:pods][:zookeeper][:client_port],
		:leader_connect => node[:pods][:zookeeper][:leader_connect],
		:leader_elect => node[:pods][:zookeeper][:leader_elect]
	})
end

# Create the client.rb file
template "/etc/kubernetes/pods/zookeeper/chef/client.rb" do
	source "client.erb"
	#mode
	#owner
	#group
	variables({
		:chef_server => node[:chef_server],
		:validation_client => node[:validation_client]
	})
end

# Create the file with the generic node name
file "/etc/kubernetes/pods/zookeeper/chef/.node_name" do 
	content "zookeeper-#{node[:pods][:zookeeper][:version]}"
	#mode
	#owner
	#group
	action :create
end

# Perform initial bootstrap operation
docker_container "chef-ubuntu-latest" do
	additional_host "#{node[:chef_server]}"
	expose "#{node[:pods][:zookeeper][:ports]}"
	volume '/etc/kubernetes/pods/zookeeper/chef:/etc/chef'
	env "ZOOKEEPER_HOME=/usr/local/zookeeper-#{node[:pods][:zookeeper][:version]}"
end

# Commit changes
docker_container "chef-ubuntu-latest" do
	tag "zookeeper"
	action :commit
end

# Push changes
docker_image "zookeeper-#{node[:pods][:zookeeper][:version]}" do
	action :push
end

# Kill the container
docker_container "chef-ubuntu-latest" do
	action :kill
end
