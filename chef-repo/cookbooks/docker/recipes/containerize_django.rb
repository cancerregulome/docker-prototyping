# Create a string from a data bag item whose contents will be the dockerfile
dockerfile = data_bag_item('dockerfiles', 'ubuntu-dockerfile')["script"].join()

# Create a string whose contents will be the knife configuration file
knife_rb = data_bag_item('configuration', 'knife_rb')["script"].join()

# Create the first-boot.json file
first_boot = data_bag_item('configuration', 'first-boot')["script"].join()

# Create links to validation keys in /var/chef

bash 'link_keys' do
	code <<-EOH
	if [[ ! -e /var/chef/client.pem && ! -e /var/chef/validation.pem ]]
	then 
	ln -s /etc/chef/client.pem /var/chef/client.pem
	ln -s /etc/chef/validation.pem /var/chef/validation.pem
	fi
	EOH
end

# Create the knife.rb configuration file
file "/etc/chef/knife.rb" do
	content knife_rb
	action :create
end

# Run the docker init command to initialize the docker context
execute "knife container docker init isb_app -f chef/ubuntu-14.04 --force -c /etc/chef/knife.rb"

# Edit the Dockerfile
file "/var/chef/dockerfiles/isb_app/Dockerfile" do
	content	dockerfile
	action	:create
end

# Replace the default first-boot.json file with the custom one
file "/var/chef/dockerfiles/isb_app/chef/first-boot.json" do
	content first_boot
	action :create
end

# Build the container
execute "knife container docker build isb_app -c /etc/chef/knife.rb --no-berks"

# Run the container
execute "docker run -d -p 80:8000 -v /etc/chef:/etc/chef/secure isb_app python test_app/manage.py runserver 0.0.0.0:8000"

