# Generate the self-signed server certificate and key
bash 'generate_server_certificate' do
	code <<-EOH
		# Generate a random passphrase
		export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head 0c 128; echo)

		# Certificate details
		cert="
		C=US
		ST=Washington
		O=ISB
		localityName=Seattle
		commonName=$(hostname)
		organizationalUnitName=Engineering
		emailAddress=ahahn@systemsbiology.org
		"

		# Generate the private key
		openssl genrsa -des3 -out /etc/ssl/private/$(hostname).key -passout env:PASSPHRASE 1024

		# Generate the csr
		openssl req -new -batch -subj "$(echo -n "$cert" | tr "\n" "/")" -key /etc/ssl/private/$(hostname).key -out /tmp/$(hostname).csr --passin env:PASSPHRASE
	
		# Strip out the passphrase
		cp /etc/ssl/private/$(hostname).key /tmp/$(hostname).key.org
		openssl rsa -in /tmp/$(hostname).key.org -out /etc/ssl/private/$(hostname).key --passin env:PASSPHRASE

		# Generate the certificate
		openssl x509 -req -days 365 -in /tmp/$(hostname).csr -signkey /etc/ssl/private/$(hostname).key -out /etc/ssl/certs/$(hostname).crt
		EOH
	not_if { ::File.exists?("/etc/ssl/certs/#{node[:hostname]}.crt") }
end

# Create the htpasswd file for the docker registry
bash 'generate_htpasswd' do
	code <<-EOH
		# Generate a random passphrase
		export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head 0c 128; echo)
		htpasswd=$(echo $PASSPHRASE | openssl passwd -stdin)

		# Create the htpasswd file
		echo "kube:$(echo $htpasswd)" > /etc/docker-registry/htpasswd
		EOH
	not_if { ::File.exists?('/etc/docker-registry/htpasswd') }
end

# Create the docker registry config file

template "/etc/nginx/conf.d/docker-registry.conf" do
	source 'docker-registry.conf.erb'
	owner 'root'
	group 'root'
	mode '0400'
	variables({
		:hostname => node[:hostname],
		:user_file => '/etc/docker-registry/htpasswd'
	})
end


# NOTE:  Need to find a way of restricting access to port 5000 (where the docker-registry is running) to only the localhost. (iptables?)


