# Install java
package "openjdk-7-jre"
package "openjdk-7-jdk"

# Install SOLR
remote_file "/tmp/solr-5.1.0.tgz" do
	source "solr-5.1.0.tgz"
	action :create_if_missing
end

# Create needed directories
directory "/var/solr" do
	action :create
	recursive true
end

directory "/opt/solr" do
	action :create
	recursive true
end

# Run the setup script with the appropriate options
execute "solr-setup" do
	command "tar xzf /tmp/solr-5.1.0.tgz /tmp/solr-5.1.0/bin/install_solr_service.sh -d /var/solr -i /opt/solr --strip-components=2"
	only_if "id -u solr"
end




