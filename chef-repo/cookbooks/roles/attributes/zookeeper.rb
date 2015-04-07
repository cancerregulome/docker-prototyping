# Zookeeper role attributes

default["roles"]["zookeeper"]["hostname_base"] = "zoo"
default["roles"]["zookeeper"]["tickTime"] = 2000
default["roles"]["zookeeper"]["data_dir"] = "/var/zookeeper"
default["roles"]["zookeeper"]["init_limit"] = 5
default["roles"]["zookeeper"]["sync_limit"] = 2
default["roles"]["zookeeper"]["servers"] = ["server.1=zoo1:2888:3888", "server.2=zoo2:2888:3888", "server.3:2888:3888"]
default["roles"]["zookeeper"]["ports"]["client_port"] = "2181"
default["roles"]["zookeeper"]["ports"]["leader_connect"] = "2888"
default["roles"]["zookeeper"]["ports"]["leader_elect"] = "3888"
default["roles"]["zookeeper"]["version"] = "3.4.6"
default["roles"]["zookeeper"]["quorum_size"] = 3
default["roles"]["zookeeper"]["environment"]["ZOOKEEPER_HOME"] = "/usr/local/zookeeper-3.4.6"

