#!/bin/bash

# Remake some directories
mkdir -p $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/zookeeper/chef/secure/trusted_certs
mkdir -p $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/tomcat/chef/secure/trusted_certs
mkdir -p $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/solr-shard/chef/secure/trusted_certs

# Restore the key files to .chef and dockerfile contexts
scp -o stricthostkeychecking=no $chef_user@$chef_server:$pem_path/$admin_client.pem .
scp -o stricthostkeychecking=no $chef_user@$chef_server:$pem_path/$validator.pem .

cp *.pem $chef_repo/.chef
cp $validator.pem $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/zookeeper/chef/secure/validation.pem
cp $validator.pem $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/tomcat/chef/secure/validation.pem
cp $validator.pem $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/solr-shard/chef/secure/validation.pem

rm *.pem

# Fetch the chef server ssl certificate
knife ssl fetch

# Copy the certificate to the dockerfile contexts for bootstrapping the containers with chef

cp $chef_repo/.chef/trusted_certs/* $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/zookeeper/chef/secure/trusted_certs
cp $chef_repo/.chef/trusted_certs/* $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/tomcat/chef/secure/trusted_certs
cp $chef_repo/.chef/trusted_certs/* $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/solr-shard/chef/secure/trusted_certs

# Download and decompress archive files for software installation on docker containers
cd $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/solr-shard/install

if [[ ! -e solr-4.10.3.tar ]]; then
	wget http://mirror.nexcess.net/apache/lucene/solr/4.10.3/solr-4.10.3.tar
fi

if [[ ! -d solr-4.10.3 ]]; then
	tar -xf solr-4.10.3.tar
fi

cd $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/zookeeper/install

if [[ ! -e zookeeper-3.4.6.tar.gz ]]; then
	wget http://mirror.reverse.net/pub/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
fi

if [[ ! -d zookeeper-3.4.6 ]]; then
	tar -xf zookeeper-3.4.6.tar.gz
fi

