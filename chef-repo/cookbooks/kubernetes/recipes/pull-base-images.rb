# Get data bag items
registry_users = data_bag_item("nginx_proxy_auth", "docker_registry_users")
registry_admin = registry_users["admin_user"]
registry_admin_password = registry_users["users"][registry_admin]

# Pull the official chef base images
docker_image "chef/ubuntu-14.04"

# Get the private registry ready to push to
docker_registry "https://#{node[:docker_registry][:environment][:registry_address]}:#{node[:docker_registry][:environment][:registry_port]}" do 
	username "#{registry_admin}"
	password "#{registry_admin_password}"
end

# Tag the image for pushing to the local registry
docker_image "chef/ubuntu-14.04" do
	repository 'chef'
	tag 'latest'
	action :tag
end

# Push images to private registry
docker_image "chef/ubuntu-14.04:latest" do
	action :push
end

