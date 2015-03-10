require 'openssl'
require 'fileutils'
require 'etc'

#include

def whyrun_supported?
	true
end

action :create do
	if @current_resource.exists
		unless updated_attributes?
			Chef::Log.info "#{ @new_resource } already up-to-date -- nothing to do."
		end
	else
		converge_by("Create self-signed SSL certificate") do
			key = OpenSSL::PKey::RSA.new File.read @new_resource.pem_key_path
			secure_key = key, @new_resource.pem_key_passphrase
			new_certificate(secure_key)		
		end
	end
end

action :create_if_missing do
	if @current_resource.exists
		Chef::Log.info "#{ @new_resource } already exists -- nothing to do."
	else
		converge_by("Create self-signed SSL certificate") do
			key = OpenSSL::PKey::RSA.new File.read @new_resource.pem_key_path
			secure_key = key, @new_resource.pem_key_passphrase
			new_certificate(secure_key)
		end	
	end
end


action :delete do
	if @current_resource.exists
		converge_by("Delete self-signed SSL certificate") do
			remove_certificate
		end
	else
		Chef::Log.info "#{ @new_resource } doesn't exist -- nothing to do."
	end
end

def new_certificate(secure_key)
	# First, make sure the file path has been created
	unless Dir.exists?(File.dirname(@new_resource.path)) do
		FileUtils.mkdir_p(File.dirname(@new_resource.path))
	end	
	# Create the certificate

	# Set the remaining file attributes
end

def remove_certificate
	FileUtils.rm(@current_resource.path)
end

def load_current_resource
	@curent_resource = Chef::Resource::SslCertificate.new(@new_resource.name)
	# More here later
	if File.exists?(@current_resource.path)
		@current_resource.exists = true
	end
end

def updated_attributes?
	# Update the resource attributes on the server, and return true if any were actually changed
	result = true
	# More here later
	return result
end


