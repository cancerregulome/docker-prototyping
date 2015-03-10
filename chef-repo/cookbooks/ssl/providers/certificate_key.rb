require 'openssl'
require 'fileutils'

def whyrun_supported?
	true
end

action :create do
	if @current_resource.exists
		unless updated_attributes?
			Chef::Log.info "#{ @new_resource } already up-to-date -- nothing to do."
		end
			
	else
		converge_by("Create RSA private key") do
			new_key	
		end	

	end
end

action :create_if_missing do
	if @current_resource.exists
		Chef::Log.info "#{ @new_resource } already exists -- nothing to do."
	else
		converge_by("Create RSA private key") do
			new_key
		end
	end
	
end

action :delete do
	if @current_resource.exists
		converge_by("Delete RSA private key") do
			remove_key
		end
	else
		Chef::Log.info "#{ @new_resource } doesn't exist -- nothing to do."
	end
end

def new_key 
	# First, make sure the file path has been created
	unless Dir.exists?(File.dirname(@new_resource.path)) do
		FileUtils.mkdir_p(File.dirname(@new_resource.path))
	end
	# Generate the new key
	key = OpenSSL::PKey::RSA.new @new_resource.modulus
	cipher = OpenSSL::Cipher.new @new_resource.cipher
	secure_key = key.export cipher, @new_resource.passphrase
	open @new_resource.path, 'w' do |io| io.write secure_key.to_pem end	

	# Set the remaining file attributes
end

def remove_key
	FileUtils.rm(@current_resource.path)
end

def load_current_resource
	@current_resource = Chef::Resource::SslCertificateKey.new(@new_resource.name)
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
