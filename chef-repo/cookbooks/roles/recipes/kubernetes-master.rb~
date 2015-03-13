# Kubernetes master role recipes

include_recipe "kubernetes::kube-install"
include_recipe "kubernetes::kube-config"
include_recipe "kubernetes::kube-master-config"
include_recipe "docker-registry::registry-config"
include_recipe "nginx-proxy::nginx-install"
include_recipe "nginx-proxy::nginx-proxy-config"
include_recipe "kubernetes::kube-master-services"
include_recipe "kubernetes::pull-base-images"
include_recipe "kubernetes::update-pods"
