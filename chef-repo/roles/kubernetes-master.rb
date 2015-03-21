# Kubernetes Master Role Definition

name "kubernetes-master"
description "The kubernetes master node role"
run_list "recipe[roles::kubernetes-master]"
### FOR DEVELOPMENT/TESTING ONLY
# Override attributes
override_attributes "docker" => { "options" => "--insecure-registry #{node[:hostname]}:443", "init_type" => "systemd" }

