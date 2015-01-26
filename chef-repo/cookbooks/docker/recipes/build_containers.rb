# Testing the container setup/bootstrap procedure

# Create a string whose contents will be the knife configuration file
knife_rb = data_bag_item('configuration', 'knife_rb')["script"].join()

# Create the knife.rb configuration file
file "/etc/chef/knife.rb" do
	content knife_rb
	action :create
end

execute 'knife container docker init test/django --force -c /etc/chef/knife.rb'

execute 'knife container docker build test/django --no-berks -c /etc/chef/knife.rb'

#execute 'docker run -d -p 80:8000 -v /etc/chef:/etc/chef/secure test/django'
