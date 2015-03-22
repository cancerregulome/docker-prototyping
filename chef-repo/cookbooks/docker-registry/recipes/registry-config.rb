# registry-config.rb

# Get data bag items (should be encryptyed later)
users = data_bag_item('nginx_proxy_auth','docker_registry_users')['users']
admin = data_bag_item('nginx_proxy_auth','docker_registry_users')['admin_user']
admin_password = users[admin]

# Override a few attributes in the current cookbook
node.default["docker_registry"]["custom_docker"]["service"]["https_proxy"] = "https://#{admin}:#{admin_password}@#{node[:hostname]}:#{node[:docker-registry][:nginx_conf][:ssl_port]}"

# Add drop-in snippets for the docker service file, and then reload it
node[:docker_registry][:config_files][:custom_docker].each do |snippet|
	template "#{node[:docker_registry][:config_files][:custom_docker][snippet]}" do
		source "#{node[:docker_registry][:templates][:custom_docker][snippet]}.erb"
		owner 'root'
		group 'root'
		mode '0700'
	end
end

service 'docker' do
  provider Chef::Provider::Service::Systemd
  action :reload
end

# Create the docker registry storage path 
directory node[:docker_registry][:primary_config][:storage_path] do
	action :create
end

# Create the docker registry config file
# NOTE:  The only value currently updated is the value for the "local" storage flavor... add node attributes and corresponding variables in the template as needed when storage flavor needs change.
template "#{node[:docker_registry][:config_files][:primary_config_file]}" do
	source "#{node[:docker_registry][:templates][:primary_config]}"
	owner 'root'
	group 'root'
	mode '0700'
	variables({
		:storage_path => node[:docker_registry][:primary_config][:storage_path]
	})
end

# Create the service init script
template "#{node[:docker_registry][:config_files][:service_file]}" do
	source "#{node[:docker_registry][:templates][:service]}"
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
template "#{node[:docker_registry][:config_files][:environment_file]}" do
	source "#{node[:docker_registry][:templates][:environment]}"
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

# Create the docker-registry nginx config file for nginx proxy authentication
template "#{node[:nginx_proxy][:conf_d_path]}/docker-registry.conf" do
	source "#{node[:nginx_proxy][:templates][:conf_d]}"
	cookbook 'nginx_proxy'
	owner 'root'
	group 'root'
	mode '0400'
	variables({
		:pem_key => "#{node[:nginx_proxy][:pem_key_path]}/#{node[:hostname]}.pem",
		:certificate => "#{node[:nginx_proxy][:certificate_path]}/#{node[:hostname]}.crt",
		:htpasswd_file => "#{node[:nginx_proxy][:htpasswd_path]}/docker-registry",
		:domain_name => node[:docker_registry][:nginx_conf][:domain_name],
		:ssl_port => node[:docker_registry][:nginx_conf][:ssl_port],
		:proxied_host => node[:docker_registry][:environment][:registry_address],
		:proxied_port => node[:docker_registry][:environment][:registry_port]
	})
end

# Create an nginx htpasswd file for the docker registry username/password combinations 
nginx_proxy_htpasswd_file "#{node[:nginx_proxy][:htpasswd_path]}/docker-registry" do
	owner 'root'
	group 'root'
	mode 0400
end

users.keys.each do |user|
	password = users[user]["password"]
	
	nginx_proxy_htpasswd_file "#{node[:nginx_proxy][:htpasswd_path]}/docker-registry" do
		owner 'root'
		group 'root'
		mode 0400
		user "#{user}"
		password "#{password}"
		action :add_entry
	end
end	


