name "zookeeper"
description "A container that will run an instance of Apache Zookeeper"
run_list "recipe[zookeeper]", "recipe[zookeeper::configure]", "recipe[zookeeper::start]"
