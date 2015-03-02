# registry-config.rb

# Create the docker registry config file
cookbook_file "config_sample.yml" do 
	path node[:docker_registry][:storage_path]
end

# Create the service init script
template "/etc/init.d/docker-registry" do
	source "docker-registry.erb"
	owner 'root'
	group 'root'
	mode '0440'
	variables({
		:host_port => node[:docker_registry][:host_port],
		:container_port => node[:docker_registry][:container_port],
		:storage_path => node[:docker_registry][:storage_path],
		:settings_flavor => node[:docker_registry][:settings_flavor]
	})
end

