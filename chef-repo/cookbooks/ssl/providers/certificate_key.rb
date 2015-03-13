require 'openssl'
require 'fileutils'

def whyrun_supported?
	true
end

action :create do
	if @current_resource.exists
		unless updated_attributes?
			Chef::Log.info "#{ @current_resource } already up-to-date -- nothing to do."
		end
			
	else
		converge_by("Create RSA private key") do
			new_key	
		end	

	end
end

action :create_if_missing do
	if @current_resource.exists
		Chef::Log.info "#{ @current_resource } already exists -- nothing to do."
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
		Chef::Log.info "#{ @current_resource } doesn't exist -- nothing to do."
	end
end

def new_key 
	# First, make sure the file path has been created
	unless Dir.exists?(File.dirname(@current_resource.path)) 
		FileUtils.mkdir_p(File.dirname(@current_resource.path))
	end
	# Generate the new key
	key = OpenSSL::PKey::RSA.new @current_resource.modulus
	cipher = OpenSSL::Cipher.new @current_resource.cipher
	secure_key = key.export cipher, @current_resource.passphrase
	open @current_resource.path, 'w' do |io| io.write secure_key.to_pem end	

	# Set permissions
	FileUtils.chmod(@current_resource.mode, @current_resource.path)
	
	# Set ownership
	FileUtils.chown(@current_resource.owner, @current_resource.group, @current_resource.path)
	
end

def remove_key
	FileUtils.rm(@current_resource.path)
end

def load_current_resource
	@current_resource = Chef::Resource::SslCertificateKey.new(@new_resource.name)
	@current_resource.name(@new_resource.name)
	@current_resource.owner(@new_resource.owner)
	@current_resource.group(@new_resource.group)
	@current_resource.mode(@new_resource.mode)
	@current_resource.path(@new_resource.path)
	@current_resource.passphrase(@new_resource.passphrase)
	@current_resource.modulus(@new_resource.modulus)
	@current_resource.cipher(@new_resource.cipher)
	
	if File.exists?(@current_resource.path)
		@current_resource.exists = true
	else
		@current_resource.exists = false
	end
end

def updated_attributes?
	# Update the resource attributes on the server, and return true if any were actually changed
	result = false
	
	# Update permissions
	current_mode = sprintf("%o", File.stat(@current_resource.path).mode)
	bits = @current_resource.mode.length
	
	if @current_resource.mode != current_mode[(-1*bits), -1]
		FileUtils.chmod(@current_resource.mode, @current_resource.path)
		result = true
	end
	
	# Update ownership
	current_owner = Etc.getpwuid(File.stat(@current_resource.path).uid).name
	current_group = Etc.getgrgid(File.stat(@current_resource.path).gid).name
	
	if @current_resource.owner != current_owner || @current_resource.group != current_group
		FileUtils.chown(@current_resource.owner, @current_resource.group, @current_resource.path)
		result = true
	end
	
	return result
end
