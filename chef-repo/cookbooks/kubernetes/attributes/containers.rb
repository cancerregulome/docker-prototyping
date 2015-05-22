# Container configuration attributes
default["kubernetes"]["containers"]["zookeeper"]["tick_time"] = 2000
default["kubernetes"]["containers"]["zookeeper"]["data_dir"] = "/var/zookeeper"
default["kubernetes"]["containers"]["zookeeper"]["init_limit"] = 5
default["kubernetes"]["containers"]["zookeeper"]["sync_limit"] = 2
default["kubernetes"]["containers"]["zookeeper"]["version"] = "3.4.6"
default["kubernetes"]["containers"]["zookeeper"]["environment"]["ZOOKEEPER_HOME"] = "/zookeeper-3.4.6"
