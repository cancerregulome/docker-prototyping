# nginx-proxy-config.rb

# Create variables for the encrypted databag items required for authentication
certificate_details = data_bag_item('certificate_generation', 'nginx_proxy')
pem_key_passphrase = certificate_details["pem_key_passphrase"]
subj_hash = certificate_details["cert_subject"]
subj = ""
subj_hash.keys.each do |entry|
	subj = subj + "#{entry}=#{subj_hash[entry]}/"
end

# Generate the self-signed certificate
ssl_certificate "#{node[:nginx_proxy][:certificate_path]}/#{node[:hostname]}.crt" do
	owner 'root'
	group 'root'
	mode '0400'
	subj_string "#{subj}"
	pem_key_passphrase "#{pem_key_passphrase}"
end


# NOTE:  Need to find a way of restricting access to port 5000 (where the docker-registry is running) to only the localhost. (iptables?)


