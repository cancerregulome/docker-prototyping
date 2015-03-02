# Upload zookeeper-controller.json
template "/kubernetes/pods/zookeeper/zookeeper-controller.json" do

end

# Create the zookeeper container
docker_image "chef-ubuntu-latest" do
	tag "zookeeper"
	action :push
end
	
