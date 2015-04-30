# Kubernetes Pod Manager Role Definition

name "container-manager"
description "The container manager role"
run_list "recipe[roles::container-manager]"