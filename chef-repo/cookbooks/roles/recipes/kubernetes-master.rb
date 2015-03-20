# Kubernetes master role recipes

include_recipe "kubernetes::kube-install"
include_recipe "kubernetes::kube-config"
include_recipe "kubernetes::kube-master-config"

if node.chef_environment == "production"
	include_recipe "nginx"
	include_recipe "nginx_proxy"
	include_recipe "nginx_proxy::nginx-proxy-config"
	include_recipe "docker-registry::registry-config"
	include_recipe "kubernetes::kube-master-services"
	include_recipe "kubernetes::pull-base-images"
else
	include_recipe "kubernetes::static-dockerfiles"
end

include_recipe "kubernetes::configure-pods"
include_recipe "kubernetes::start-pods"
include_recipe "kubernetes::update-pods" # For demonstration purposes only in anything but a production setting

