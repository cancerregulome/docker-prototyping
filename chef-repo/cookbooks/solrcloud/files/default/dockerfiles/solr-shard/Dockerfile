# BASE chef/ubuntu-12.04:latest
Apache Solr Container
FROM chef/ubuntu-14.04
ADD chef/ /etc/chef/
ONBUILD RUN rm -rf /etc/chef/secure/*
ONBUILD ADD install/solr-4.10.3.tar /usr/local/
ONBUILD RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
ONBUILD EXPOSE 7574
ONBUILD EXPOSE 8983
ONBUILD ENTRYPOINT ["chef-init"]
ONBUILD CMD ["--onboot"]
