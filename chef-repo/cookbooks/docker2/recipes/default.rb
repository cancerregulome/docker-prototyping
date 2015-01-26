#
# Cookbook Name:: docker2
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/docker/contexts/django" do
	recursive true	
	action :create
end

cookbook_file "Dockerfile" do
	path "/docker/contexts/django/Dockerfile"
	action :create
end

execute "docker build -t django /docker/contexts/django"

execute "docker run -d -p 80:8000 django"




