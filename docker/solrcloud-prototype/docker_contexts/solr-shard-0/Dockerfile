FROM ubuntu:14.04
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
COPY install/solr-5.2.1.tgz /solr-5.2.1.tgz
COPY install/solr-5.2.1.tgz /tmp/solr-5.2.1.tgz
RUN tar -xf /solr-5.2.1.tgz && /solr-5.2.1/bin/install_solr_service.sh /tmp/solr-5.2.1.tgz
COPY solr/* /var/solr/
EXPOSE 8983
CMD ["/solr-5.2.1/bin/solr", "start", "-f", "-c", "-V", "-s", "/var/solr", "-h", "core0", "-z", "localhost:2181,localhost:2182,localhost:2183", "-DnumShards=2"]

# Run instructions:  docker run -d -P -v /titan/cancerregulome9/workspaces/users/ahahn/docker-prototyping/docker/solrcloud-prototype/data:/var/solr/data -h core0 solr-shard-0
