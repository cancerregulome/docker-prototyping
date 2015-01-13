# Create a string whose contents will be the dockerfile
dockerfile = data_bag_item('dockerfiles', 'ubuntu-dockerfile')["script"].join()

# Create a string whose contents will be the knife configuration file
knife_rb = data_bag_item('configuration', 'knife_rb')["script"].join()

# Create links to validation keys in /var/chef

bash 'link_keys' do
	code <<-EOH
	ln -s /etc/chef/client.pem /var/chef/client.pem
	ln -s /etc/chef/validation.pem /var/chef/validation.pem
	EOH
end

# Create the knife.rb configuration file
file "/etc/chef/knife.rb" do
	content knife_rb
	action :create
end

# Run the docker init command to initialize the docker context
execute "knife container docker init vardaofthevalier/isb_app --force -c /etc/chef/knife.rb"

STDOUT.write Chef::Config[:knife][:dockerfiles_path]

# Edit the Dockerfile
file "/var/chef/dockerfiles/vardaofthevalier/isb_app/Dockerfile" do
	content	dockerfile
	action	:create
end

# Build the container
execute "knife container docker build vardaofthevalier/isb_app -c /etc/chef/knife.rb"

# Run the container
execute "docker run -d -P -v /etc/chef:/etc/chef/secure vardaofthevalier/isb_app"

