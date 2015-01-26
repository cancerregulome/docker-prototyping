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

# Install Ruby 2.0
apt_package 'ruby2.0' do
	action :install
end

# Install ruby-dev package
apt_package 'ruby-dev' do
	action :install
end

# Install Ruby (2.2.0), RubyGems, and the knife-container gem

gem_package 'knife-container' do
	action :install
end

# Get rid of any files that aren't needed
execute 'apt-get clean'




