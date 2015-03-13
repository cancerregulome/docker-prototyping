# Node attributes for the individual pods (kubernetes master perspective)

# Zookeeper pod
default['pods']['zookeeper']['ports']['client_port'] = '2181'
default['pods']['zookeeper']['ports']['leader_connect'] = '2888'
default['pods']['zookeeper']['ports']['leader_elect'] = '3888'
default['pods']['zookeeper']['version'] = '3.4.6'

# Solr pod

