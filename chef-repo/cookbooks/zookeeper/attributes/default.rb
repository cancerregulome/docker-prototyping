default["zookeeper"]["hostname_base"] = "zoo"
default["zookeeper"]["tickTime"] = 2000
default["zookeeper"]["data_dir"] = "/var/zookeeper"
default["zookeeper"]["init_limit"] = 5
default["zookeeper"]["sync_limit"] = 2
default["zookeeper"]["servers"] = ["server.1", "server.2", "server.3"]
default["zookeeper"]["ports"]["client_port"] = "2181"
default["zookeeper"]["ports"]["leader_connect"] = "2888"
default["zookeeper"]["ports"]["leader_elect"] = "3888"
default["zookeeper"]["version"] = "3.4.6"
default["zookeeper"]["quorum_size"] = 3
default["zookeeper"]["environment"]["ZOOKEEPER_HOME"] = "/usr/local/zookeeper-3.4.6"

