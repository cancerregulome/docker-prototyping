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
		:pod_name => node[:roles][:zookeeper][:hostname_base],
		:version => node[:roles][:zookeeper][:version],
		:client_port => node[:roles][:zookeeper][:ports][:client_port],
		:leader_connect => node[:roles][:zookeeper][:ports][:leader_connect],
		:leader_elect => node[:roles][:zookeeper][:ports][:leader_elect],
		:quorum_size => node[:roles][:zookeeper][:quorum_size]
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
