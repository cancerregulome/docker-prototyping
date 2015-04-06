name "solr-cluster"
description "The solr cluster environment"
cookbook []
default_attributes(
	:zookeeper => { 
		:configured_zookeepers => 0,
		:quorum_size => 3,
		:servers => [ "server.1=zookeeper-3.4.6-1:2888:3888", "server.2=zookeeper-3.4.6-2:2888:3888", "server.3=zookeeper-3.4.6-3:2888:3888" ]
	}
)

# NOTE: Will need to write logic to dynamically generate the server mappings when autoscaling code is written. 