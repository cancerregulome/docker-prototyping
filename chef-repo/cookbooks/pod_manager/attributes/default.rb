# Pod attributes
# Zookeeper pod attributes
default["pods"]["zookeeper"]["replication_controller"]["v1beta3"]["metadata"]["name"] = "zookeeper-controller"
default["pods"]["zookeeper"]["replication_controller"]["v1beta3"]["metadata"]["labels"]["name"] = "zookeeper"
default["pods"]["zookeeper"]["replication_controller"]["v1beta3"]["spec"]["replicas"] = 1
default["pods"]["zookeeper"]["replication_controller"]["v1beta3"]["spec"]["selector"]["name"] = "solr-zookeeper-pod"
default["pods"]["zookeeper"]["replication_controller"]["v1beta3"]["spec"]["template"]["metadata"]["labels"]["name"] = "solr-zookeeper"
default["pods"]["zookeeper"]["replication_controller"]["v1beta3"]["spec"]["template"]["spec"]["restartPolicy"] = "onFailure"
default["pods"]["zookeeper"]["replication_controller"]["v1beta3"]["spec"]["template"]["spec"]["containers"] = [ {"name": "solr-zookeeper", "image": "gcr.io/isb-cgc/solr-zookeeper", "ports": [ { "name": "client-port", "containerPort": 2181 }, { "name": "leader-connect", "containerPort": 2888 }, { "name": "leader-elect", "containerPort": 3888 } ] ]
default["pods"]["zookeeper"]["currently_running"] = 0
default["pods"]["zookeeper"]["quorum_size"] = 3

# General pod attributes
default["pods"]["definitions"] = []


