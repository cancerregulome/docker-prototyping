# Create a string whose contents will be the dockerfile
dockerfile = data_bag_item('dockerfiles', 'ubuntu-dockerfile')["script"].join()

# Install RVM in a docker user's home directory
bash "rvm_install" do
	user 'abby'
	code <<-EOH
	curl -sSL https://rvm.io/mpapis.asc | gpg --import -
	curl -sSL https://get.rvm.io | bash -s stable
	source $HOME/.rvm/scripts/rvm
	rvm install 2.2.0
	rvm use 2.2.0
	gem install knife-container
	EOH
end

# Run the docker init command to initialize the docker context
execute "container_init" do
	environment "PATH" => "/home/abby/.rvm/bin:#{ENV["PATH"]}"
	command "knife container docker init ubuntu:latest --force"
end

# Edit the Dockerfile
file "#{Chef::Config[:knife][:dockerfiles_path]}/ubuntu:latest/Dockerfile" do
	content	dockerfile
	action	:create
end

# Build the container
execute "container_build" do
	environment "PATH" => "/home/abby/.rvm/bin:#{ENV["PATH"]}"
	command "knife container docker build ubuntu:latest"
end

# Run the container
execute "container_run" do
	environment "PATH" => "/home/abby/.rvm/bin:#{ENV["PATH"]}"
	command "knife container docker run -d -v /etc/chef:/etc/chef/secure:ro ubuntu:latest"
end
