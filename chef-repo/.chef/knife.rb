log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               "#{ENV['chef_repo']}/.chef/admin.pem"
validation_client_name   'tcga-validator'
validation_key           "#{ENV['chef_repo']}/.chef/tcga-validator.pem"
chef_server_url          "#{ENV['chef_server_url']}"
syntax_check_cache_path  "#{ENV['chef_repo']}/.chef/syntax_check_cache"
cookbook_path	[ "#{ENV['chef_repo']}/cookbooks" ]
