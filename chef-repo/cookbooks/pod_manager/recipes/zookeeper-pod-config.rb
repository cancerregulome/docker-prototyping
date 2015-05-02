# Create the zookeeper controller file

template "/etc/kubernetes/pods/zookeeper/zookeeper-controller.json" do
	source "replication-controller.erb"
	mode '0400'
	owner 'root'
	group 'root'
	variables({
		:replication_controller_id => node[:pods][:zookeeper][:replication_controller][:id],
		:replica_selector => node[:pods][:zookeeper][:replication_controller][:replica_selector],
		:quorum_size => node[:pods][:zookeeper][:replication_controller][:replication_factor],
		:containers => node[:pods][:zookeeper][:pod_template][:manifest][:containers],
		:pod_id => node[:pods][:zookeeper][:pod_template][:manifest][:id]
	})
end

