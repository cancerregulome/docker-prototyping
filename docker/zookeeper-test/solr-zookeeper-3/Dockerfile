# BASE chef/ubuntu-12.04:latest
# Apache Zookeeper Container
FROM ubuntu:14.04
COPY install/zookeeper-3.4.6.tar.gz /
RUN tar -xf zookeeper-3.4.6.tar.gz && rm zookeeper-3.4.6.tar.gz
ENV ZOOKEEPER_HOME /zookeeper-3.4.6
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
RUN mkdir -p /var/lib/zookeeper
COPY conf/zoo.cfg /zookeeper-3.4.6/conf/
COPY conf/myid /var/lib/zookeeper/
EXPOSE 2181
EXPOSE 2888
EXPOSE 3888
COMMAND ["java", "-cp", 
"zookeeper.jar:lib/slf4j-api-1.7.5.jar:lib/slf4j-log4j12-1.7.5.jar:lib/log4j-1.2.16.jar:conf", 
"org.apache.zookeeper.server.quorum.QuorumPeerMain", "zoo.cfg"]
