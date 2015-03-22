# Kubernetes Master Role Definition

name "kubernetes-master"
description "The kubernetes master node role"
run_list "recipe[roles::kubernetes-master]"

# Override attributes
override_attributes "docker" => {  
	"init_type" => "systemd" 
}

