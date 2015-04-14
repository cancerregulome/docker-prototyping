# Kubernetes Master Role Definition

name "kubernetes-master"
description "The kubernetes master node role"
run_list "recipe[roles::kubernetes-master]"

# Override attributes
override_attributes "docker" => {  
	"options" => "--insecure-registry=localhost:5000",
	"init_type" => "systemd" 
}

