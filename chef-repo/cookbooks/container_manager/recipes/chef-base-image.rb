# Build the chef base image

#require 'docker'

execute 'chef-base-image' do
	command "docker build -t chef_base /etc/kubernetes/pods/dockerfiles/chef_base"
	not_if "docker images | grep chef_base"
end

#node.default["container_manager"]["images"].push("chef_base")





