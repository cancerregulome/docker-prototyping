# nginx-proxy-config.rb

# Create variables for the encrypted databag items required for authentication
certificate_details = data_bag_item('certificate_generation', 'nginx_proxy')
pem_key_passphrase = certificate_details["pem_key_passphrase"]

# Generate an RSA key (required for the self-signed certificate)
ssl_certificate_key "#{node[:nginx_proxy][:pem_key_path]}/#{node[:hostname]}.pem" do
	owner 'root'
	group 'root'
	mode '0400'
	modulus '2048'
	cipher 'AES-128-CBC'
end

# Create the subject file for the certificate request
template "#{node[:nginx_proxy][:crt_request_path]}/#{node[:hostname]}" do
	source "#{node[:nginx_proxy][:templates][:crt_request]}"
	owner 'root'
	group 'root'
	mode '0400'
	variables({ #from encrypted databag
		:country_name => certificate_details["cert_subject"]["C"],
		:locality => certificate_details["cert_subject"]["L"],
		:state_or_province => certificate_details["cert_subject"]["S"],
		:organization_name => certificate_details["cert_subject"]["O"],
		:organizational_unit => certificate_details["cert_subject"]["OU"],
		:common_name => node[:hostname]
	})
end

# Generate the self-signed certificate
ssl_certificate "#{node[:nginx_proxy][:certificate_path]}" do
	owner 'root'
	group 'root'
	mode '0400'
	subj_file "#{node[:nginx_proxy][:crt_request_path]}/#{node[:hostname]}"
	pem_key "#{node[:nginx_proxy][:pem_key_path]}/#{node[:hostname]}.pem"
	pem_key_passphrase "#{pem_key_passphrase}"
end


# NOTE:  Need to find a way of restricting access to port 5000 (where the docker-registry is running) to only the localhost. (iptables?)


