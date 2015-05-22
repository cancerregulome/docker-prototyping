# Create the zookeeper controller files

controllers = 1
node[:kubernetes][:replication_controllers][:zookeeper][:quorum_size].times do
	newVolumes = node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:spec][:template][:spec][:volumes]
	newHostDir = "#{newVolumes[0][:hostDir]}-#{controllers}"
	newVolumes[0][:hostDir] = newHostDir
	template "/etc/kubernetes/replication_controllers/zookeeper/zookeeper-controller-#{controllers}.json" do
		source "replication_controllers/replication-controller.json.erb"
		mode '0400'
		owner 'root'
		group 'root'
		variables({
			:rc_metadata_name => "#{node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:metadata][:name]}-#{controllers}",
			:rc_metadata_label_name => "#{node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:metadata][:labels][:name]}-#{controllers}",
			:rc_spec_replicas => node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:spec][:replicas],
			:rc_spec_selector_name => "#{node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:spec][:selector][:name]}-#{controllers}",
			:rc_spec_template_metadata_label_name => "#{node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:spec][:template][:metadata][:labels][:name]}-#{controllers}",
			:rc_spec_template_spec_restartpolicy => node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:spec][:template][:spec][:restartPolicy],
			:rc_spec_template_spec_containers => node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:spec][:template][:spec][:containers],
			:rc_spec_template_spec_volumes => newVolumes
		})
	end
	node[:kubernetes][:replication_controllers][:definitions].push("/etc/kubernetes/pods/zookeeper/zookeeper-controller-#{controllers}.json")
	controllers += 1
end

