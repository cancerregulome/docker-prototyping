require 'chef/provisioning'
require 'chef/provisioning/docker_driver'

test_var=node[:solr_cluster_roles][:zookeeper][:hostname_base]
# Upload the chef configuration directory for zookeeper
directory "/etc/kubernetes/pods/zookeeper" do
	mode '0400'
	owner 'root'
	group 'root'
	action :create
	recursive true
end

# Create the zookeeper controller file
template "/etc/kubernetes/pods/zookeeper/zookeeper-controller.json" do
	source "zookeeper-controller.erb"
	mode '0400'
	owner 'root'
	group 'root'
	variables({
		:pod_name => node[:solr_cluster_roles][:zookeeper][:hostname_base],
		:version => node[:solr_cluster_roles][:zookeeper][:version],
		:client_port => node[:solr_cluster_roles][:zookeeper][:ports][:client_port],
		:leader_connect => node[:solr_cluster_roles][:zookeeper][:ports][:leader_connect],
		:leader_elect => node[:solr_cluster_roles][:zookeeper][:ports][:leader_elect],
		:quorum_size => node[:solr_cluster_roles][:zookeeper][:quorum_size]
	})
end

# Create the base image for zookeeper
machine_image "zookeeper-#{node[:solr_cluster_roles][:zookeeper][:version]}" do
	recipe 'roles::zookeeper'
	driver 'docker'	
	machine_options :docker_options => {
		:base_image => {
			:name => 'ubuntu',
			:repository => 'ubuntu',
			:tag => 'latest'
		},
		:env => {
		"ZOOKEEPER_HOME" => node[:solr_cluster_roles][:zookeeper][:environment][:zookeeper_home]
		},
	
		:command => "java -cp $ZOOKEEPER_HOME/zookeeper-3.4.6.jar:$ZOOKEEPER_HOME/lib/slf4j-api-1.6.1.jar:$ZOOKEEPER_HOME/lib/slf4j-log4j12-1.6.1.jar:$ZOOKEEPER_HOME/lib/log4j-1.2.15.jar:conf \ org.apache.zookeeper.server.quorum.QuorumPeerMain $ZOOKEEPER_HOME/conf/zoo.cfg",

		:ports => node[:solr_cluster_roles][:zookeeper][:ports].values
	}
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
