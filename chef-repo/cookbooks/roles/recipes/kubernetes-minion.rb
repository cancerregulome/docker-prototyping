# Kubernetes minion node recipes

include_recipe "kubernetes::kube-install"
include_recipe "kubernetes::kube-config"
include_recipe "kubernetes::kube-minion-config"
include_recipe "kubernetes::kube-minion-services"
