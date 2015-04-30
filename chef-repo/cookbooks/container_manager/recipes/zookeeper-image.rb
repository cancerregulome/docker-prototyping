#Build the zookeeper image

require 'docker'

ruby 'zookeeper-image' do
	block do
		zookeeper_image = Docker::Image.build_from_dir("/etc/kubernetes/pods/dockerfiles/apps/zookeeper")
		zookeeper_image.tag('repo' => 'zookeeper')
	end
	not_if { Docker::Image.exist?(zookeeper_image.id)}
end