# Kubernetes master role recipes

include_recipe "kubernetes::kube-config"
include_recipe "kubernetes::kube-master-config"
include_recipe "kubernetes::kube-master-services"


