node_name                   ENV['HOSTNAME']
chef_server_url             'https://chef-server-centos.com/organizations/isb'
validation_client_name      'isb-validator'
validation_key              '/etc/chef/secure/validation.pem'
client_key                  '/etc/chef/secure/client.pem'
trusted_certs_dir           '/etc/chef/secure/trusted_certs'
ssl_verify_mode             :verify_peer
