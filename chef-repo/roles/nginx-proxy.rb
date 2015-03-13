# nginx proxy role definition

name "nginx-proxy"
description "The nginx proxy node role"
run_list "recipe[roles::nginx-proxy]"
