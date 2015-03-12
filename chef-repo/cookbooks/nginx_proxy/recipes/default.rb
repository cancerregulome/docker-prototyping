#
# Cookbook Name:: nginx-proxy
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'nginx'

chef_gem 'htauth' do
	action :install
end

