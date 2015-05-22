# Create the zookeeper controller files

controllers = 1
node[:kubernetes][:pods][:zookeeper][:quorum_size].times do
	template "/etc/kubernetes/pods/zookeeper/zookeeper-controller-#{controllers}.json" do
		source "replication-controller.erb"
		mode '0400'
		owner 'root'
		group 'root'
		variables({
			:rc_metadata_name => "#{node[:kubernetes][:pods][:zookeeper][:replication_controller][:v1beta3][:metadata][:name]}-#{controllers}",
			:rc_metadata_label_name => "#{node[:kubernetes][:pods][:zookeeper][:replication_controller][:v1beta3][:metadata][:labels][:name]}-#{controllers}",
			:rc_spec_replicas => node[:kubernetes][:pods][:zookeeper][:replication_controller][:v1beta3][:spec][:replicas],
			:rc_spec_selector_name => "#{node[:kubernetes][:pods][:zookeeper][:replication_controller][:v1beta3][:spec][:selector][:name]}-#{controllers}",
			:rc_spec_template_metadata_label_name => "#{node[:kubernetes][:pods][:zookeeper][:replication_controller][:v1beta3][:spec][:template][:metadata][:labels][:name]}-#{controllers}",
			:rc_spec_template_spec_restartpolicy => node[:kubernetes][:pods][:zookeeper][:replication_controller][:v1beta3][:spec][:template][:spec][:restartPolicy],
			:rc_spec_template_spec_containers => node[:kubernetes][:pods][:zookeeper][:replication_controller][:v1beta3][:spec][:template][:spec][:containers]
		})
	end
	node[:kubernetes][:pods][:definitions].push("/etc/kubernetes/pods/zookeeper/zookeeper-controller-#{controllers}.json")
	controllers += 1
end

