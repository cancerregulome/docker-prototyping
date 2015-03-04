#!/bin/bash

# Restore the key files to .chef and container contexts
scp -o stricthostkeychecking=no $chef_user@$chef_server:$pem_path/$admin_client.pem .
scp -o stricthostkeychecking=no $chef_user@$chef_server:$pem_path/$validator.pem .

#cp *.pem $chef_repo/.chef
cp $validator.pem $chef_repo/cookbooks/pods/files/default/zookeeper/chef/secure/validation.pem
cp $validator.pem $chef_repo/cookbooks/pods/files/default/solr/tomcat/chef/secure/validation.pem
cp $validator.pem $chef_repo/cookbooks/pods/files/default/solr/solr-shard/chef/secure/validation.pem

rm *.pem

# Fetch the chef server ssl certificate
knife ssl fetch

# Copy the certificate to the dockerfile contexts for bootstrapping the containers with chef

cp $chef_repo/.chef/trusted_certs/* $chef_repo/cookbooks/pods/files/default/zookeeper/chef/secure/trusted_certs
cp $chef_repo/.chef/trusted_certs/* $chef_repo/cookbooks/pods/files/default/solr/tomcat/chef/secure/trusted_certs
cp $chef_repo/.chef/trusted_certs/* $chef_repo/cookbooks/pods/files/default/solr/solr-shard/chef/secure/trusted_certs

# Download archive files for software installation on docker containers
cd $chef_repo/cookbooks/solr-shard/files/default/install

if [[ ! -e solr-5.0.0.tar ]]; then
	wget http://apache.claz.org/lucene/solr/5.0.0/solr-5.0.0.tgz
fi

#cd $chef_repo/cookbooks/zookeeper/files/default/install

if [[ ! -e zookeeper-3.4.6.tar.gz ]]; then
	wget http://mirror.reverse.net/pub/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
fi


