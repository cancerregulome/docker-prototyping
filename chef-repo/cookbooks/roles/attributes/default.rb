# Solr cluster role attributes
# Zookeeper role attributes
default["solr_cluster_roles"]["zookeeper"]["hostname_base"] = "zoo"
default["solr_cluster_roles"]["zookeeper"]["tickTime"] = 2000
default["solr_cluster_roles"]["zookeeper"]["data_dir"] = "/var/zookeeper"
default["solr_cluster_roles"]["zookeeper"]["init_limit"] = 5
default["solr_cluster_roles"]["zookeeper"]["sync_limit"] = 2
default["solr_cluster_roles"]["zookeeper"]["servers"] = ["server.1", "server.2", "server.3"]
default["solr_cluster_roles"]["zookeeper"]["ports"]["client_port"] = "2181"
default["solr_cluster_roles"]["zookeeper"]["ports"]["leader_connect"] = "2888"
default["solr_cluster_roles"]["zookeeper"]["ports"]["leader_elect"] = "3888"
default["solr_cluster_roles"]["zookeeper"]["version"] = "3.4.6"
default["solr_cluster_roles"]["zookeeper"]["quorum_size"] = 3
default["solr_cluster_roles"]["zookeeper"]["environment"]["ZOOKEEPER_HOME"] = "/usr/local/zookeeper-3.4.6"

