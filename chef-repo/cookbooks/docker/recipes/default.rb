#
# Cookbook Name:: docker
# Recipe:: default
#
# Author: Abigail Hahn
#
# Description: This recipe performs all necessary installations required to create and run docker containers after the bootstrap process has completed.
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Make sure packages are up to date
execute 'apt-get update'

# Install build-essential
apt_package 'build-essential' do
	action :install
end

# Install docker
apt_package 'docker.io' do
	action :install
end

# Install Ruby (2.2.0), RubyGems, and the knife-container gem

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
	cd ~
	rm -r $rubytmp
	gem install knife-container
	EOH
end

# Get rid of any files that aren't needed
execute "apt-get clean"

