# nginx-proxy htpasswd file provider

require 'fileutils'
require 'htauth'

def whyrun_supported?
	true
end

action :create do

end

action :create_if_missing do

end

action :append do

end

action :delete do 

end

def load_current_resource do
	@current_resource = Chef::Resource::Nginx-proxyHtpasswordFile
end

def update_attributes? do

end