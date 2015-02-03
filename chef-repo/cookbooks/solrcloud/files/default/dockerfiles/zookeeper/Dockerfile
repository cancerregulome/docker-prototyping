# BASE chef/ubuntu-12.04:latest
# Apache Zookeeper Container
FROM chef/ubuntu-14.04
ADD chef/ /etc/chef/
ONBUILD RUN rm -rf /etc/chef/secure/*
ONBUILD ADD install/zookeeper-3.4.6.tar.gz /usr/local/
ONBUILD RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
ONBUILD EXPOSE 2181
ONBUILD EXPOSE 2888
ONBUILD EXPOSE 3888
ONBUILD ENTRYPOINT ["chef-init"]
ONBUILD CMD ["--onboot"]
