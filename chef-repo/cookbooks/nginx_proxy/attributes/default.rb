# nginx_proxy attributes

default['nginx_proxy']['conf_d'] = "/etc/nginx/conf.d"
default['nginx_proxy']['pem_key_path'] = "/etc/ssl/private"
default['nginx_proxy']['certificate_path'] = "/etc/ssl/certs"
default['nginx_proxy']['htpasswd_file'] = "/etc/nginx/htpasswd"
default['nginx_proxy']['crt_request'] = "/etc/ssl/certs/request"

# Application specific attributes
default['nginx_proxy']['docker_registry']['proxied_host'] = "localhost"
default['nginx_proxy']['docker_registry']['proxied_port'] = "5000"