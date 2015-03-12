# nginx-proxy-config.rb

# Create variables for the encrypted databag items required for authentication


# Generate an RSA key (required for the self-signed certificate)
ssl_certificate_key node[:nginx_proxy][:pem_key_path] do
	owner 'root'
	group 'root'
	mode '0400'
	modulus '2048'
	cipher 'AES-128-CBC'
end

# Create the subject file for the certificate request
template "#{default['nginx_proxy']['crt_request']}/#{node[:hostname]}" do
	source 'subj.erb'
	owner 'root'
	group 'root'
	mode '0400'
	variables({ #from encrypted databag
	
	})
end

# Generate the self-signed certificate
ssl_certificate node[:nginx_proxy][:certificate_path] do
	owner 'root'
	group 'root'
	mode '0400'
	subj_file "#{default['nginx_proxy']['crt_request']}/#{node[:hostname]}"
	pem_key node[:nginx_proxy][:pem_key_path]
	pem_key_passphrase #from encrypted databag
end

# Create the htpasswd file for the docker registry
nginx_proxy_htpasswd_file node[:nginx_proxy][:htpasswd_file] do
	owner 'root'
	group 'root'
	mode '0400'
	
end

# Create the docker registry config file
template "/etc/nginx/conf.d/docker-registry.conf" do
	source 'proxy-conf.erb'
	owner 'root'
	group 'root'
	mode '0400'
	variables({
		:pem_key => node[:nginx_proxy][:pem_key_path],
		:certificate => node[:nginx_proxy][:certificate_path],
		:htpasswd_file => node[:nginx_proxy][:htpasswd_file],
		:proxied_host => node[:nginx_proxy][:docker_registry][:proxied_host],
		:proxied_port => node[:nginx_proxy][:docker_registry][:proxied_host]
	})
end


# NOTE:  Need to find a way of restricting access to port 5000 (where the docker-registry is running) to only the localhost. (iptables?)


