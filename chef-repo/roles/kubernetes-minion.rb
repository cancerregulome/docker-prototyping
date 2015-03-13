# The Kubernetes Minion Role Definition
name "kubernetes-minion"
description "The kubernetes slave node role"
run_list "recipe[roles::kubernetes-minion]"
