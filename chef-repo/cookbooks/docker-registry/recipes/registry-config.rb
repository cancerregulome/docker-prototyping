# registry-config.rb

# Create the docker registry storage path
directory "#{node[:docker_registry][:config][:storage_path]}" do
	action :create
end

# Create the docker registry config file
# NOTE:  The only values that are updated are the values for the "local" storage flavor... add node attributes and corresponding variables as needed when storage flavor needs change.
template "/etc/docker-registry.yml" do
	source "config.erb"
	owner 'root'
	group 'root'
	mode '0700'
	variables({
		:storage_path => node[:docker_registry][:config][:storage_path]
	})
end

# Create the service init script
template "/usr/lib/systemd/system/docker-registry.service" do
	source "service.erb"
	owner 'root'
	group 'root'
	mode '0700'
	variables({
		:description => node[:docker_registry][:service][:description],
		:type => node[:docker_registry][:service][:type],
		:environment_vars => node[:docker_registry][:service][:environment_vars],
		:environment_file => node[:docker_registry][:service][:environment_file],
		:working_directory => node[:docker_registry][:service][:working_directory],
		:exec_start => node[:docker_registry][:service][:exec_start],
		:restart_policy => node[:docker_registry][:service][:restart_policy],
		:wanted_by => node[:docker_registry][:service][:wanted_by]
	})
end

# Create the environment file
template "/etc/sysconfig/docker-registry" do
	source "environment.erb"
	owner 'root'
	group 'root'
	mode '0700'
	variables({
		:config_file => node[:docker_registry][:environment][:config_file],
		:settings_flavor => node[:docker_registry][:environment][:settings_flavor],
		:registry_address => node[:docker_registry][:environment][:registry_address],
		:registry_port => node[:docker_registry][:environment][:registry_port],
		:gunicorn_workers => node[:docker_registry][:environment][:gunicorn_workers]
	})
end

# Edit the docker environment file to handle the insecure registry
# NOTE: This is a temporary solution to the problem of being forced to use authentication based access to the private docker registry when using the docker_registry resource in chef.  In production, it will be better to have an authentication proxy set up to handle access to the docker registry for security reasons.
template "/etc/sysconfig/docker" do
	source "docker_environment.erb" 
	owner 'root'
	group 'root'
	mode '0700'
	variables({
		:insecure_registry => node[:docker_registry][:environment][:insecure_registry]
	})
end
