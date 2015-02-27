log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/home/abby/docker-prototyping/chef-repo/.chef/admin.pem'
validation_client_name   'tcga-validator'
validation_key           '/home/abby/docker-prototyping/chef-repo/.chef/tcga-validator.pem'
chef_server_url          'https://chef-server-centos.com/organizations/tcga'
syntax_check_cache_path  '/home/abby/docker-prototyping/chef-repo/.chef/syntax_check_cache'
cookbook_path	[ "/home/abby/docker-prototyping/chef-repo/cookbooks" ]
