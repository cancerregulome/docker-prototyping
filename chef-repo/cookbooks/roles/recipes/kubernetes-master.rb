# Kubernetes master role recipes

include_recipe "nginx"
include_recipe "nginx_proxy"
include_recipe "nginx_proxy::nginx-proxy-config"
include_recipe "docker-registry::registry-config"
include_recipe "kubernetes"
include_recipe "kubernetes::kube-install"
include_recipe "kubernetes::kube-config"
include_recipe "kubernetes::kube-master-config"
include_recipe "kubernetes::kube-master-services"
include_recipe "kubernetes::create-images"
#include_recipe "kubernetes::static-dockerfiles"  # workaround for lack of a valid CA for signing certificates
include_recipe "kubernetes::configure-pods"
include_recipe "kubernetes::start-pods"
#include_recipe "kubernetes::update-pods" # should be moved to the kubernetes minion?

