# Nginx proxy role definition

name "nginx-proxy"
description "The nginx proxy role"
run_list "recipe[roles::nginx-proxy]"
