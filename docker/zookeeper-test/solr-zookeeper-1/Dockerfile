# BASE chef/ubuntu-12.04:latest
# Apache Zookeeper Container
FROM ubuntu:14.04
COPY install/zookeeper-3.4.6.tar.gz /
RUN tar -xf zookeeper-3.4.6.tar.gz && rm zookeeper-3.4.6.tar.gz
ENV ZOOKEEPER_HOME /zookeeper-3.4.6
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
RUN mkdir -p /var/lib/zookeeper
#COPY conf/zoo.cfg /zookeeper-3.4.6/conf/zoo.cfg
#COPY conf/1 /var/lib/zookeeper/myid
COPY startup/startup.sh 
EXPOSE 2181
EXPOSE 2888
EXPOSE 3888
WORKDIR /zookeeper-3.4.6
