# kube-minion-config.rb

# /etc/kubernetes/kubelet
template "/etc/kubernetes/kubelet" do
	source "kubelet.erb"
	mode '0440'
	owner 'root'
	group 'root'
	variables({
		:kubelet_address => node[:kubernetes][:kubelet_address],
		:kubelet_port => node[:kubernetes][:ports][:kubelet_port],
		:kubelet_args => node[:kubernetes][:kubelet_args]
	})
end