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
attribute :subj_file, :kind_of => String, :required => true
attribute :pem_key, :kind_of => String, :required => true, :callbacks => { "pem key not found" => lambda { |file| ParameterValidation.file_exists?(file) }, "pem key not valid" => lambda { |file| ParameterValidation.valid_pem_file?(file) } }
attribute :pem_key_passphrase, :kind_of => String, :required => true # Encrypted data bag item

attr_accessor :exists


