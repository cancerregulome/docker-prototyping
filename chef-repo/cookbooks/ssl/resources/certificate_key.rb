# ssl_certificate_key resource

require 'openssl'
require 'etc'

actions :create, :delete, :create_if_missing
default_action :create

attribute :owner, :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ], :default => ENV['USER'], :callbacks => { "User doesn't exist on the system" => lambda { |owner| owner_exists?(owner) } }
attribute :group, :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ], :default => Etc.getgrgid(Etc.getpwnam(ENV['USER'])[:gid])[:name], :callbacks => { "Group doesn't exist on the system" => lambda { |group| group_exists?(group) } }
attribute :mode, :kind_of => String, :regex => /^0?\d{3,4}$/, :default => '0777', :callbacks => { "Invalid file mode" => lambda { |mode| valid_file_mode?(mode) } }
attribute :path, :kind_of => String, :name_attribute => true, :required => true
attribute :passphrase, :kind_of => String, :required => true
attribute :modulus, :kind_of => String, :default => '2048', :callbacks => { "Insecure key (<1024 bits)" => lambda { |mod| mod >= 1024 } }
attribute :cipher, :kind_of => String, :equal_to => OpenSSL::Cipher.ciphers, :default => 'AES-128-CBC', :callbacks => { "Invalid cipher" => lambda { |cipher| OpenSSL::Cipher.ciphers.include?(cipher) } }

attr_accessor :exists

def owner_exists?(owner)
	result = true
	begin
		Etc.getpwnam(owner)
	rescue
		result = false
	end
	
	return result
end

def group_exists?(group)
	result = true
	begin
		Etc.getgrgid(group)
	rescue
		result = false
	end

	return result

end

def valid_file_mode?(mode)
	result = true
	# each of the four bits must be a sum of any of 4(read), 2(write), 1(execute), or be equal to 0.
	mode.each_byte do |bit|
		if bit.chr.to_i < 0 || bit.chr.to_i > 7
			result = false
			break
		end
	end
	
	return result
end






