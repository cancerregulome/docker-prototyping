#Build the zookeeper image

#require 'docker'

execute 'zookeeper-image' do
	command "docker build -t zookeeper /etc/kubernetes/pods/dockerfiles/apps/zookeeper"
	not_if "docker images | grep zookeeper"
end
