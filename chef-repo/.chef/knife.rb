log_level                :info
log_location             STDOUT
node_name                "#{ENV['admin_client']}"
client_key               "#{ENV['chef_repo']}/.chef/#{ENV['admin_client']}.pem"
validation_client_name   "#{ENV['validator']}"
validation_key           "#{ENV['chef_repo']}/.chef/#{ENV['validator']}.pem"
chef_server_url          "https://#{ENV['chef_server']}/organizations/isb"
syntax_check_cache_path  "#{ENV['chef_repo']}/.chef/syntax_check_cache"
cookbook_path [ "#{ENV['chef_repo']}/cookbooks" ]
