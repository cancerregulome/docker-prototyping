# Create the zookeeper service definition

template "/etc/kubernetes/services/zookeeper-service.json" do
	source "services/service.json.rb"
	mode '0400'
	owner 'root'
	group 'root'
	variables({
		:service_name => node[:kubernetes][:services][:zookeeper][:v1beta3][:metadata_name],
		:service_label_name => node[:kubernetes][:services][:zookeeper][:v1beta3][:metadata_label_name],
		:service_ports => node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:service_ports],
		:service_selector => node[:kubernetes][:replication_controllers][:zookeeper][:v1beta3][:metadata][:labels]
	})
end
