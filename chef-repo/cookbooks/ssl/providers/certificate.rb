require 'openssl'
require 'fileutils'

#include

def whyrun_supported?
	true
end

action :create do
	converge_by("Create SSL certificate key") do
		if !@current_resource.exists || !server_match?
			if !File.exist?("/etc/ssl/private/#{node[:hostname]}.pem") || !pass_phrase_match?
			
				key = OpenSSL::PKey::RSA.new @new_resource.modulus
				cipher = OpenSSL::Cipher.new @new_resource.cipher
				secure_key = key.export cipher, @new_resource.pass_phrase
				
				open "#{node[:hostname]}.pem", 'w' do |io| io.write secure_key.to_pem end
				FileUtils.mv("#{node[:hostname]}.pem", "/etc/ssl/private/#{node[:hostname]}.pem"
			else
			
				key = OpenSSL::PKey::RSA.new File.read "/etc/ssl/private/#{node[:hostname]}.key"
				secure_key = key, @new_resource.pass_phrase
				
			end
			
			# create the certificate
			
		end	
	end
end

def server_match?
	#unless... 
end

def pass_phrase_match?
	#unless...
end