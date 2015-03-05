# Pull the official chef base images
docker_image "chef/ubuntu-14.04"

# Get the private registry ready to push to
#docker_registry "localhost:5000"

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

