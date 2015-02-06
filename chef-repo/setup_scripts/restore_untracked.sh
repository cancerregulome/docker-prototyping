#!/bin/bash

# Set the script environment

source chef_dev_env.sh

# Restore the key files to .chef and dockerfile contexts
scp -o stricthostkeychecking=no $chef_user@$chef_server:$pem_path/$admin.pem .
scp -o stricthostkeychecking=no $chef_user@$chef_server:$pem_path/$validator.pem .

cp *.pem $chef_repo/.chef
cp $validator.pem $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/zookeeper/chef/secure/validation.pem
cp $validator.pem $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/tomcat/chef/secure/validation.pem
cp $validator.pem $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/solr-shard/chef/secure/validation.pem

# Configure knife utility for this copy of the repo
knife configure --admin-client-name $admin_client --admin-client-key $chef_repo/.chef/$admin_client.pem -r $chef_repo --validation-client-name $validator --validation-key $chef-repo/.chef/$validator.pem -s https://$chef_server -y

# Fetch the chef server ssl certificate
knife ssl fetch

# Copy the certificate to the dockerfile contexts for bootstrapping the containers with chef
cp trusted_certs/* $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/zookeeper/chef/secure/trusted_certs
cp trusted_certs/* $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/tomcat/chef/secure/trusted_certs
cp trusted_certs/* $chef_repo/cookbooks/solrcloud/files/default/dockerfiles/solr-shard/chef/secure/trusted_certs

# Download archive files for software installation on docker containers
cd ../cookbooks/solrcloud/files/default/dockerfiles/solr-shard/install
wget http://mirror.nexcess.net/apache/lucene/solr/4.10.3/solr-4.10.3.tgz

cd ../../zookeeper/install
wget http://mirror.reverse.net/pub/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz

