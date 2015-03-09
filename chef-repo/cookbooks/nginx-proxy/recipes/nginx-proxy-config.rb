# Generate the self-signed server certificate and key
bash 'generate_server_certificate' do
	code <<-EOH
		# Generate a random passphrase
		export pass=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo)

		# Certificate details
		export cert="
		C=US
		ST=Washington
		O=ISB
		localityName=Seattle
		commonName=$(hostname)
		organizationalUnitName=Engineering
		emailAddress=ahahn@systemsbiology.org"

		# Generate the private key
		openssl genrsa -des3 -out $(hostname).key -passout env:pass 1024

		# Generate the csr
		openssl req -new -batch -subj "$(echo -n "$cert" | tr "\n" "/")" -key $(hostname).key -out $(hostname).csr -passin env:pass
	
		# Strip out the passphrase
		cp $(hostname).key $(hostname).key.org
		openssl rsa -in $(hostname).key.org -out $(hostname).key -passin env:pass

		# Generate the certificate
		openssl x509 -req -days 365 -in $(hostname).csr -signkey $(hostname).key -out $(hostname).crt

		# Move the files to the correct locations
		mv $(hostname).key /etc/ssl/private
		mv $(hostname).crt /etc/ssl/certs
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


