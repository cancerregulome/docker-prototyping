# Kubernetes Master Role Definition

name "kubernetes-master"
description "The kubernetes master node role"
run_list "recipe[roles::kubernetes-master]"
### FOR DEVELOPMENT/TESTING ONLY
# Override attributes
override_attributes "docker" => {  
	"init_type" => "systemd" 
}

