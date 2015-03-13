# nginx_proxy attributes

# Application specific config files
default['nginx_proxy']['conf_d_path'] = "/etc/nginx/conf.d"
default['nginx_proxy']['templates']['conf_d'] = "proxy-conf.erb"
default['nginx_proxy']['pem_key_path'] = "/etc/ssl/private"
default['nginx_proxy']['certificate_path'] = "/etc/ssl/certs"
default['nginx_proxy']['htpasswd_path'] = "/etc/nginx/htpasswd"

# SSL crt request files
default['nginx_proxy']['crt_request_path'] = "/etc/ssl/certs/request"
default['nginx_proxy']['templates']['crt_request'] = "crt-request.erb"


