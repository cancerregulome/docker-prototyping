# Pull base images from Docker Hub
docker_image "chef/ubuntu-14.04"

# login to private docker registry
docker_registry 'https://localhost:#{node[:docker_registry][:host_port]}'

# Tag and push base images to private repo 
docker_image "chef/ubuntu-14.04" do 
	tag "chef-ubuntu-latest"
	action :push
end
