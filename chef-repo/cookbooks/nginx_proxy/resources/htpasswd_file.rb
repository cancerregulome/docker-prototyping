# nginx-proxy htpasswd file resource

$:.unshift *Dir[::File.expand_path('../../files/default/vendor/gems/**/lib', __FILE__)]

require 'htauth'
require 'etc'
require_relative '../files/default/custom/modules/parameter-validation'

actions :create, :create_if_missing, :add_entry, :update_entry, :delete_entry, :delete
default_action :create

attribute :owner, :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ], :default => ENV['USER'], :callbacks => { "User doesn't exist on the system" => lambda { |owner| ParameterValidation.owner_exists?(owner) } }
attribute :group, :regex => [ /^([a-z]|[A-Z]|[0-9]|_|-)+$/, /^\d+$/ ], :default => Etc.getgrgid(Etc.getpwnam(ENV['USER'])[:gid])[:name], :callbacks => { "Group doesn't exist on the system" => lambda { |group| ParameterValidation.group_exists?(group) } }
attribute :mode, :regex => /^0?\d{3,4}$/, :default => 0777
attribute :path, :kind_of => String, :name_attribute => true, :required => true
attribute :user, :kind_of => String # Encrypted databag item
attribute :password, :kind_of => String # Encrypted databag item
attribute :encryption_algorithm, :kind_of => String, :equal_to => HTAuth::Algorithm.sub_klasses.keys, :default => "crypt", :callbacks => { "Invalid encryption algorithm" => lambda { |algorithm| HTAuth.Algorithm.sub_klasses.keys.include?(algorithm) } }

attr_accessor :exists
