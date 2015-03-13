# kube-config.rb

# Modify /etc/kubernetes/config 
template "/etc/kubernetes/config" do
	source "config.erb"
	mode '0440' # verify this
	owner 'root'
	group 'root'
	variables({
		:kube_master => node[:kubernetes][:kube_master]
		:etcd_port => node[:kubernetes][:ports][:etcd_port]
		:kube_logtostderr => node[:kubernetes][:logtostderr]
		:kube_log_level => node[:kubernetes][:kube_log_level]
		:kube_allow_priv => node[:kubernetes][:kube_allow_priv]
	})
end



