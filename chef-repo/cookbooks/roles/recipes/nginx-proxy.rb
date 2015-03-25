# Nginx-proxy role recipes

include_recipe "nginx"
include_recipe "nginx_proxy"
include_recipe "nginx_proxy::nginx-proxy-config"