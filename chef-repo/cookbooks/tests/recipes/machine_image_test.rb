require 'chef/provisioning/docker_driver'

machine_image 'zookeeper-test' do
	recipe 'zookeeper'
	driver 'docker'
	machine_options :docker_options => {
		:base_image => {
			:name => 'ubuntu',
			:repository => 'ubuntu',
			:tag => '14.04'
		}
	}
end
