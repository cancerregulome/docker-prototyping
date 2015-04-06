# Upload the chef configuration directory for zookeeper
directory "/etc/kubernetes/pods/zookeeper" do
	files_mode '0400'
	files_owner 'root'
	mode '0400'
	owner 'root'
	group 'root'
	action :create
end

# Create the zookeeper controller file
template "/etc/kubernetes/pods/zookeeper/zookeeper-controller.json" do
	source "zookeeper-controller.erb"
	mode '0400'
	owner 'root'
	group 'root'
	variables({
		:version => node[:pods][:zookeeper][:version],
		:client_port => node[:pods][:zookeeper][:client_port],
		:leader_connect => node[:pods][:zookeeper][:leader_connect],
		:leader_elect => node[:pods][:zookeeper][:leader_elect]
		:quorum_size => node[:zookeeper][:quorum_size]
	})
end


# Create the client.rb file
#template "/etc/kubernetes/pods/zookeeper/chef/client.rb" do
#	source "client.erb"
#	mode '0400'
#	owner 'root'
#	group 'root'
#	variables({
#		:chef_server => node[:chef_server],
#		:validation_client => node[:validation_client]
#	})
#end

# Create the file with the generic node name
#file "/etc/kubernetes/pods/zookeeper/chef/.node_name" do 
#	content "zookeeper-#{node[:pods][:zookeeper][:version]}"
#	mode '0400'
#	owner 'root'
#	group 'root'
#	action :create
#end
