# kube-master-config.rb

# Modify /etc/kubernetes/apiserver

template "/etc/kubernetes/apiserver" do
	source "apiserver.erb"
	mode '0440' #verify this
	owner 'root'
	group 'root'
	variables({
		:kube_api_address => node[:kubernetes][:kube_api_address],
		:kube_api_port => node[:kubernetes][:ports][:kube_api_port],
		:kube_master => node[:kubernetes][:kube_master],
		:kubelet_port => node[:kubernetes][:ports][:kubelet_port],
		:kube_service_addresses => node[:kubernetes][:kube_service_addresses],
		:kube_api_args => node[:kubernetes][:kube_api_args]
	})
end

# Modify /etc/kubernetes/controller-manager
# Note: this requires that the provisioning of the kubernetes minions has already occurred
template "/etc/kubernetes/controller-manager" do
	source "controller-manager.erb"
	mode '0440'
	owner 'root'
	group 'root'
	variables({
		:kubelet_addresses => node[:kubernetes][:kube_minions]
	})
end


	
