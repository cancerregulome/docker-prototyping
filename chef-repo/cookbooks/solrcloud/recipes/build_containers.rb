require 'pathname'

chef_server_host = node.default['chef-server']['hostname']
chef_server_ip = node.default['chef-server']['ipaddress']

# Start the docker daemon
execute "service docker start"

# Build the containers (3 steps)
Dir.glob("/dockerfiles/**").each do |docker_context|
	container_name = Pathname.new(docker_context).basename
	execute "docker build -t #{container_name} #{docker_context}"
	execute "docker run -d --add-host=#{chef_server_host}:#{chef_server_ip} -v #{docker_context}/chef/secure:/etc/chef/secure #{container_name} chef-init --bootstrap"
	execute "docker build -t #{container_name} #{docker_context}"
end




