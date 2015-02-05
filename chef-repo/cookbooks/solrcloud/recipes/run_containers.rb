require 'pathname'

# For now, use some attributes in this cookbook's default.rb attributes file to specify details about the chef server.  Try to find a better solution later.
chef_server_host = node.default['chef-server']['fqdn']
chef_server_ip = node.default['chef-server']['ipaddress']

# Run each container
Dir.glob("/dockerfiles/**").each do |docker_context|
	container_name = Pathname.new(docker_context).basename
	port_string = ""
	node.default['ports']["#{container_name}"].each do |port|
		port_string << "-p #{port} "
	end	
	execute "docker run -d #{port_string}--add-host=#{chef_server_host}:#{chef_server_ip} -v #{docker_context}/chef:/etc/chef #{container_name}"
end
