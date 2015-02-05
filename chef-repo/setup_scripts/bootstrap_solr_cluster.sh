#! /bin/bash

read -s -p "Enter the chef server user password: " password

node_num=1

while read host; do
	echo "server.$node_num=$host:2888:3888" >> ../cookbooks/solrcloud/files/default/dockerfiles/zookeeper/config/zoo.cfg
	(( node_num += 1))
done <solr_cluster_nodes

node_num=1

while read host; do
	knife bootstrap --sudo --ssh-user chef --ssh-password $password --no-host-key-verify -v "recipe[solrcloud], recipe[solrcloud::build_containers], recipe[solrcloud::run_containers]" -j "{'zookeeper_id':'$node_num'}" $host
	(( node_num += 1 ))
done <solr_cluster_nodes
