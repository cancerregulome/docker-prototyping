# ssl_certificate resource

require 'openssl'
require 'etc'
require_relative '../files/default/custom/modules/parameter-validation'

actions :create, :delete, :create_if_missing
default_action :create

attribute :owner, :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ], :default => ENV['USER'], :callbacks => { "User doesn't exist on the system" => lambda { |owner| ParameterValidation.owner_exists?(owner) } }
attribute :group, :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ], :default => Etc.getgrgid(Etc.getpwnam(ENV['USER'])[:gid])[:name], :callbacks => { "Group doesn't exist on the system" => lambda { |group| ParameterValidation.group_exists?(group) } }
attribute :mode, :regex => /^0?\d{3,4}$/, :default => '0777', :callbacks => { "Invalid file mode" => lambda { |mode| ParameterValidation.valid_file_mode?(mode) } }
attribute :path, :kind_of => String, :name_attribute => true, :required => true
attribute :subj_string, :kind_of => String, :required => true
attribute :pem_key_modulus, :kind_of => String, :default => '2048', :callbacks => { "Insecure key (<1024 bits)" => lambda { |mod| mod.to_i >= 1024 } }
attribute :pem_key_cipher, :kind_of => String, :equal_to => OpenSSL::Cipher.ciphers, :default => 'AES-128-CBC', :callbacks => { "Invalid cipher" => lambda { |cipher| OpenSSL::Cipher.ciphers.include?(cipher) } }
attribute :pem_key_passphrase, :kind_of => String, :required => true 

attr_accessor :exists


