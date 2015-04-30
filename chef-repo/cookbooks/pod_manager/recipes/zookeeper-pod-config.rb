# Create the zookeeper controller file
template "/etc/kubernetes/pods/zookeeper/zookeeper-controller.json" do
	source "zookeeper-controller.erb"
	mode '0400'
	owner 'root'
	group 'root'
	variables({
		:pod_name => node[:solr_cluster_roles][:zookeeper][:hostname_base],
		:image_name => 'zookeeper',
		:version => node[:solr_cluster_roles][:zookeeper][:version],
		:client_port => node[:solr_cluster_roles][:zookeeper][:ports][:client_port],
		:leader_connect => node[:solr_cluster_roles][:zookeeper][:ports][:leader_connect],
		:leader_elect => node[:solr_cluster_roles][:zookeeper][:ports][:leader_elect],
		:quorum_size => node[:solr_cluster_roles][:zookeeper][:quorum_size]
	})
end

