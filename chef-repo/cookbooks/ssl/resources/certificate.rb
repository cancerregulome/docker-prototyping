# ssl_certificate resource

actions :create, :delete, :create_if_missing
default_action :create

attribute :owner, :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ], :default => ENV['USER'], :callbacks => { "User doesn't exist on the system" => lambda { |owner| owner_exists?(owner) } }
attribute :group, :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ], :default => Etc.getgrgid(Etc.getpwnam(ENV['USER'])[:gid])[:name], :callbacks => { "Group doesn't exist on the system" => lambda { |group| group_exists?(group) } }
attribute :mode, :regex => /^0?\d{3,4}$/, :default => '0777'
attribute :path, :kind_of => String, :name_attribute => true, :required
attribute :pem_key_path, :kind_of => String, :required, :callbacks => { "pem key not found" => lambda { |file| file_exists?(file) }, "pem key not valid" => lambda { |file| valid_pem_file?(file) } }
attribute :pem_key_passphrase, :kind_of => String, :required # Encrypted data bag item

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

def file_exists?(file)

end

def valid_pem_file?(file)

end


