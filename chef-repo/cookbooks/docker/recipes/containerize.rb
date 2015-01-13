dockerfile = data_bag_item('dockerfiles', 'ubuntu-dockerfile')["script"].join()

bash "ruby_setup" do
	code <<-EOH
	rubytmp=`mktemp -d`
	cd $rubytmp
	wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz
	wget http://production.cf.rubygems.org/rubygems/rubygems-2.4.5.tgz	
	tar -xf ruby-2.2.0.tar.gz
	tar -xf rubygems-2.4.5.tgz
	cd ruby-2.2.0
	./configure
	make
	make install
	cd $rubytmp/rubygems-2.4.5
	ruby setup.rb
	gem install knife-container
	cd $HOME
	EOH
end

execute "knife container docker init ubuntu:latest --force"

file "#{Chef::Config[:knife][:dockerfiles_path]}/ubuntu:latest/Dockerfile" do
	content	dockerfile
	action	:create
end

execute "knife container docker build ubuntu:latest"

execute "knife container docker run -d -v /etc/chef:/etc/chef/secure:ro ubuntu:latest"
