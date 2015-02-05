# BASE chef/ubuntu-12.04:latest
Apache Solr Container
FROM chef/ubuntu-14.04
ADD install/solr-4.10.3.tar /usr/local/
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
EXPOSE 7574
EXPOSE 8983
ENTRYPOINT ["chef-init"]
CMD ["--onboot"]
