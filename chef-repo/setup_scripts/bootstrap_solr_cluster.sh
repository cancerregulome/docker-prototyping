#!/bin/bash

read -s -p "Enter the chef user's password for the chef cluster: " password

node_num=1

while read host; do
	echo "server.$node_num=$host:2888:3888" >> $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/zookeeper/config/zoo.cfg
	(( node_num += 1))
done <$chef_repo/setup_scripts/zookeeper_quorum

node_num=1

while read host; do
	knife bootstrap --sudo --ssh-user $chef_user --use-sudo-password -P $password --no-host-key-verify -r "recipe[solrcloud], recipe[solrcloud::build_containers], recipe[solrcloud::run_containers]" -j "{\"node_id\":\"$node_num\"}" $host
	(( node_num += 1 ))
done <$chef_repo/setup_scripts/solr_cluster_nodes
