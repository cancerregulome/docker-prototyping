#
# Cookbook Name:: nginx-proxy
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Make sure all of the nginx config directories exist
directory "#{node[:nginx_proxy][:htpasswd_path]}" do
	action :create
end

directory "#{node[:nginx_proxy][:crt_request_path]}" do
	action :create
end

directory "#{node[:nginx_proxy][:pem_key_path]}" do
	action :create
end

directory "#{node[:nginx_proxy][:certificate_path]}" do
	action :create
end

