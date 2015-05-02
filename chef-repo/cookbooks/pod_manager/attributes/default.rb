# Pod attributes
# Zookeeper pod attributes
default["pods"]["zookeeper"]["replication_controller"]["id"] = "zookeeper-controller"
default["pods"]["zookeeper"]["replication_controller"]["replication_factor"] = 3
default["pods"]["zookeeper"]["replication_controller"]["replica_selector"]["name"] = "zookeeper-quorum"
default["pods"]["zookeeper"]["pod_template"]["manifest"]["containers"]["zookeeper"]["name"] = "zookeeper"
default["pods"]["zookeeper"]["pod_template"]["manifest"]["containers"]["zookeeper"]["image"] = "zookeeper"
default["pods"]["zookeeper"]["pod_template"]["manifest"]["containers"]["zookeeper"]["entrypoint"] = "/usr/bin/supervisord"
default["pods"]["zookeeper"]["pod_template"]["manifest"]["containers"]["zookeeper"]["ports"]["client-port"] = 2181
default["pods"]["zookeeper"]["pod_template"]["manifest"]["containers"]["zookeeper"]["ports"]["leader-connect"] = 2888
default["pods"]["zookeeper"]["pod_template"]["manifest"]["containers"]["zookeeper"]["ports"]["leader-elect"] =3888
default["pods"]["zookeeper"]["pod_template"]["manifest"]["id"] = "zookeeper"
default["pods"]["zookeeper"]["currently_running"] = 0


