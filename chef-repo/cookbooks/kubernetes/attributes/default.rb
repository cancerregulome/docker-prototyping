# kubernetes node attributes

# The kubernetes master hostname -- this should be set by the chef provisioning node, eventually.
default['kubernetes']['kube_master'] = 'kube-master' 

# The kubernetes minions -- these should be set by the chef provisioning node, eventually.
default['kubernetes']['kube_minions'] = ["kube-minion1", "kube-minion2"]

# kubernetes ports
default['kubernetes']['ports']['etcd_port'] = '4001'
default['kubernetes']['ports']['kube_api_port'] = '8080'
default['kubernetes']['ports']['kubelet_port'] = '10250'

# kubernetes services
# NOTE: deleted nginx and docker-registry services -- will move to respective roles
default['kubernetes']['kube_master_services'] = [ "etcd", "kube-apiserver", "kube-controller-manager", "docker", "docker-registry" ]
default['kubernetes']['kube_minion_services'] = [ "kube-proxy", "kubelet", "kube-scheduler", "docker" ]

# /etc/kubernetes/config
default['kubernetes']['logtostderr'] = "true"
default['kubernetes']['kube_log_level'] = "0"
default['kubernetes']['kube_allow_priv'] = "false"

# /etc/kubernetes/apiserver
default['kubernetes']['kube_api_address'] = "0.0.0.0"
default['kubernetes']['kube_service_addresses'] = "10.254.0.0/16"
default['kubernetes']['kube_api_args'] = ""# Not sure yet

# /etc/kubernetes/controller-manager 

# /etc/kubernetes/kubelet
default['kubernetes']['kubelet_address'] = "0.0.0.0"
default['kubernetes']['kubelet_args'] = ""# Not sure yet

# environment variables 
default['kubernetes']['env']['chef_driver'] = "docker"


