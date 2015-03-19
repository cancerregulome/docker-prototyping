require 'openssl'
require 'fileutils'

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
			new_certificate(secure_key)		
		end
	end
end

action :create_if_missing do
	if @current_resource.exists
		Chef::Log.info "#{ @new_resource } already exists -- nothing to do."
	else
		converge_by("Create self-signed SSL certificate") do
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
	# Create the RSA key in /etc/ssl/private
	key = OpenSSL::PKey::RSA.new @current_resource.pem_key_modulus
	cipher = OpenSSL::Cipher.new @current_resource.pem_key_cipher
	secure_key = key.export cipher, @current_resource.pem_key_passphrase
	open "/etc/ssl/private/#{node[:hostname]}.pem", 'w' do |io| io.write secure_key.to_pem end	

	# Set permissions
	FileUtils.chmod(@current_resource.mode, "/etc/ssl/private/#{node[:hostname]}.pem")
	
	# Set ownership
	FileUtils.chown(@current_resource.owner, @current_resource.group, "/etc/ssl/private/#{node[:hostname]}.pem")

	# Create the certificate
	name = OpenSSL::X509::Name.parse @current_resource.subj_string
	cert = OpenSSL::X509::Certificate.new
	cert.version = 2
	cert.serial = 0 # insecure, need to choose a random two digit number?
	cert.not_before = Time.now
	cert.not_after = Time.now + 365 * 24 * 60 * 60 # 1 year from creation
	cert.public_key = secure_key.public key
	cert.subject = name
	cert.issuer = name
	cert.sign secure_key, OpenSSL::Digest::SHA1.new
	open @current_resource.path, 'w' do |io| io.write cert.to_pem end
	
	# Set permissions
	FileUtils.chmod(@current_resource.mode, @current_resource.path)
	
	# Set ownership
	FileUtils.chown(@current_resource.owner, @current_resource.group, @current_resource.path)
	
end

def remove_certificate
	FileUtils.rm(@current_resource.path)
end

def load_current_resource
	@current_resource = Chef::Resource::SslCertificate.new(@new_resource.name)
	@current_resource.name(@new_resource.name)
	@current_resource.owner(@new_resource.owner)
	@current_resource.group(@new_resource.group)
	@current_resource.mode(@new_resource.mode)
	@current_resource.path(@new_resource.path)
	@current_resource.subj_string(@new_resource.subj_string)
	@current_resource.pem_key_modulus(@new_resource.pem_key_modulus)
	@current_resource.pem_key_cipher(@new_resource.pem_key_cipher)
	@current_resource.pem_key_passphrase(@new_resource.pem_key_passphrase)
	
	# More here later
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


