# nginx-proxy-config.rb

# Create variables for the encrypted databag items required for authentication
certificate_details = data_bag_item('certificate_generation', 'nginx_proxy')
subj_hash = certificate_details["cert_subject"]
subj = ""
subj_hash.keys.each do |entry|
	subj = subj + "#{entry}=#{subj_hash[entry]}/"
end
subj = subj + "CN=#{node[:hostname]}"

# Generate the self-signed certificate
ssl_certificate "#{node[:nginx_proxy][:certificate_path]}/#{node[:hostname]}.crt" do
	owner 'root'
	group 'root'
	mode 0400
	subj_string "#{subj}"
end


# NOTE:  Need to find a way of restricting access to port 5000 (where the docker-registry is running) to only the localhost. (iptables?)


