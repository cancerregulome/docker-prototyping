# Get data bag items
registry_users = data_bag_item("nginx_proxy_auth", "docker_registry_users")
registry_admin = registry_users["admin_user"]
registry_admin_password = registry_users["users"][registry_admin]["password"]
registry_admin_email = registry_users["users"][registry_admin]["email"]

# Pull the official chef base images
docker_image "chef/ubuntu-14.04"

# Get the private registry ready to push to
#docker_registry "#{node[:hostname]}:#{node[:docker_registry][:nginx_conf][:ssl_port]}" do 
#	username "#{registry_admin}"
#	password "#{registry_admin_password}"
#	email "#{registry_admin_email}"
#end
docker_registry "localhost:5000" 

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

