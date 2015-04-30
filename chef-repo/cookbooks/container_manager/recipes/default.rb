# Copy the chef docker context to the node
remote_directory "/etc/kubernetes/pods/dockerfiles" do
	source "dockerfiles"
	recursive true
	action :create
end

