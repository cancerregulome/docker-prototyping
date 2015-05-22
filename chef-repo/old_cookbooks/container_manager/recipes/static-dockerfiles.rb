remote_directory "/etc/kubernetes/pods/dockerfiles" do
	source "dockerfiles"
	action :create
end