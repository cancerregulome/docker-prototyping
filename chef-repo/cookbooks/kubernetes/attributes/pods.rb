# Pod attributes
# Zookeeper pod attributes
default["kubernetes"]["replication_controllers"]["zookeeper"]["v1beta3"]["metadata"]["name"] = "zookeeper-controller"
default["kubernetes"]["replication_controllers"]["zookeeper"]["v1beta3"]["metadata"]["labels"]["name"] = "zookeeper"
default["kubernetes"]["replication_controllers"]["zookeeper"]["v1beta3"]["spec"]["replicas"] = 1
default["kubernetes"]["replication_controllers"]["zookeeper"]["v1beta3"]["spec"]["selector"]["name"] = "solr-zookeeper-pod"
default["kubernetes"]["replication_controllers"]["zookeeper"]["v1beta3"]["spec"]["template"]["metadata"]["labels"]["name"] = "solr-zookeeper"
default["kubernetes"]["replication_controllers"]["zookeeper"]["v1beta3"]["spec"]["template"]["spec"]["restartPolicy"] = "onFailure"
default["kubernetes"]["replication_controllers"]["zookeeper"]["v1beta3"]["spec"]["template"]["spec"]["containers"] = [ {"name": "solr-zookeeper", "image": "gcr.io/isb-cgc/solr-zookeeper", "ports": [ { "name": "client-port", "containerPort": 2181 }, { "name": "leader-connect", "containerPort": 2888 }, { "name": "leader-elect", "containerPort": 3888 } ], "volumeMounts": [ { "mountPath": "/var/zookeeper", "name": "data_dir" } ] } ]
default["kubernetes"]["replication_controllers"]["zookeeper"]["v1beta3"]["spec"]["template"]["spec"]["volumes"] = [ { "name": "data_dir", "hostDir": { "path":"/var/zookeeper" } } ]
default["kubernetes"]["replication_controllers"]["zookeeper"]["currently_running"] = 0
default["kubernetes"]["replication_controllers"]["zookeeper"]["quorum_size"] = 3
