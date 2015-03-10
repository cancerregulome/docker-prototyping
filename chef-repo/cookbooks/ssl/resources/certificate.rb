# certificate_key resource

actions :create, :create_if_missing, :delete
default_action :create

attribute :path, :kind_of => String, :name_attribute => true, :regex => []
attribute :owner, :kind_of => String, :regex => []
attribute :group, :kind_of => String, :regex => []
attribute :mode, :kind_of => String, :regex => []