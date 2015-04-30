# Build the chef base image
#docker_image 'chef_base' do
#	source "/etc/kubernetes/pods/dockerfiles/chef_base/Dockerfile"
#	#tag "tcga/chef_base"
#	action :build_if_missing
#	#notifies :run, 'execute[gcloud_push_base]', :immediately
#end
require 'docker'

ruby 'chef-base-image' do
	block do
		chef_base = Docker::Image.build_from_dir("/etc/kubernetes/pods/dockerfiles/chef_base/Dockerfile")
	end
	not_if  { "chef_base" in node.default["pod_manager"]["images"] }
end

node.default["pod_manager"]["images"].push("chef_base")





