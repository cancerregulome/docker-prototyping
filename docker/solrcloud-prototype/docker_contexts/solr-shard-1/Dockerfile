FROM ubuntu:14.04
RUN apt-get -qq update && apt-get install <java stuff> && apt-get -qq clean
COPY install/solr-5.2.1.tgz /solr-5.2.1.tgz
RUN tar -xfz solr-5.2.1.tgz solr-5.2.1/bin/install_solr_service.sh && solr-5.2.1/bin/install_solr_service.sh solr-5.2.1.tgz
EXPOSE 8983
CMD ["solr", "start", "-f", "-c", "-V", "-d", "/var/solr/data", "-s", "/var/solr", "-h", "core1", "-z", "zookeeper1,zookeeper2,zookeeper3", "-DnumShards=2"]

# Run instructions:  docker run -d -P -v /titan/cancerregulome9/workspaces/users/ahahn/solrcloud-prototype/data:/var/solr/data -h core1 solr-shard-1
