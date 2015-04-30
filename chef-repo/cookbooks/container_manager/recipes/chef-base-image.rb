# Build the chef base image

require 'docker'

ruby 'chef-base-image' do
	block do
		chef_base = Docker::Image.build_from_dir("/etc/kubernetes/pods/dockerfiles/chef_base/Dockerfile")
	end
	not_if  { Docker::Image.exist?(chef_base.id) }
end

#node.default["container_manager"]["images"].push("chef_base")





