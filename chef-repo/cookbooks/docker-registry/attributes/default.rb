# Docker registry configuration values and command line parameters

# /etc/sysconfig/docker-registry (environment file)
default['docker_registry']['config_files']['environment_file'] = "/etc/sysconfig/docker-registry"
default['docker_registry']['templates']['environment'] = "environment.erb"
default['docker_registry']['environment']['config_file'] = "/etc/docker-registry.yml"
default['docker_registry']['environment']['settings_flavor'] = "local"
default['docker_registry']['environment']['registry_address'] = "localhost"
default['docker_registry']['environment']['registry_port'] = "5000"
default['docker_registry']['environment']['gunicorn_workers'] = "4"

# /etc/init.d/docker-registry (service file)
default['docker_registry']['config_files']['service_file'] = "/etc/init.d/docker-registry"
default['docker_registry']['templates']['service'] = "service.erb"
default['docker_registry']['service']['description'] = "Registry server for Docker"
default['docker_registry']['service']['type'] = "simple"
default['docker_registry']['service']['environment_vars'] = "DOCKER_REGISTRY_CONFIG=/etc/docker-registry.yml"
default['docker_registry']['service']['environment_file'] = "/etc/sysconfig/docker-registry"
default['docker_registry']['service']['working_directory'] = "/usr/lib/python2.7/site-packages/docker-registry"
default['docker_registry']['service']['exec_start'] = "/usr/bin/gunicorn --access-logfile - --debug --max-requests 100 --graceful-timeout 3600 -t 3600 -k gevent -b ${REGISTRY_ADDRESS}:${REGISTRY_PORT} -w $GUNICORN_WORKERS docker_registry.wsgi:application"
default['docker_registry']['service']['restart_policy'] = "on-failure"
default['docker_registry']['service']['wanted_by'] = "multi-user.target"

# /etc/docker-registry.yml (config file)
default['docker_registry']['config_files']['primary_config_file'] = "/etc/docker-registry.yml"
default['docker_registry']['templates']['primary_config'] = "config.erb"
default['docker_registry']['primary_config']['storage_path'] = "/var/docker-registry"
# Add more later when values are known and needed

# /etc/nginx/conf.d/docker_registry
default['docker_registry']['nginx_conf']['domain_name'] = "tcga-registry.com"
default['docker_registry']['nginx_conf']['ssl_port'] = "443"

# /etc/systemd/system/docker.d/customenv.conf
default['docker_registry']['config_files']['custom_docker']['service'] = "/etc/systemd/system/docker.service.d/custom_service.conf"
default['docker_registry']['templates']['custom_docker']['service'] = "custom-docker-service.erb"
default['docker_registry']['custom_docker']['service']['https_proxy'] = nil # set later in recipes

# For testing/development only -- delete later
override['docker']['options'] = "--insecure-registry=#{node[:hostname]}:#{node[:docker_registry][:nginx_conf][:ssl_port]}"




