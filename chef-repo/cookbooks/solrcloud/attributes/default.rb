# chef server details
default['chef-server']['hostname'] = 'chef-server-centos'
default['chef-server']['ipaddress'] = '192.168.56.105'

# container listening ports
default['ports']['zookeeper'] = ['2181', '2888', '3888']
default['ports']['tomcat'] = ['8080']
default['ports']['solr-shard'] = ['7574', '8983']
