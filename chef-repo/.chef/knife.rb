log_level                :info
log_location             STDOUT
node_name                'tcga-admin'
client_key               "#{ENV['chef_repo']}/.chef/tcga-admin.pem"
validation_client_name   'isb-tcga-validator'
validation_key           "#{ENV['chef_repo']}/.chef/isb-tcga-validator.pem"
chef_server_url          "https://#{ENV['chef_server']}/organizations/isb-tcga"
syntax_check_cache_path  "#{ENV['chef_repo']}/.chef/syntax_check_cache"
cookbook_path	[ "#{ENV['chef_repo']}/cookbooks" ]
repo_mode	'everything'
