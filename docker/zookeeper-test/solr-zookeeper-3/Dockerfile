# BASE chef/ubuntu-12.04:latest
# Apache Zookeeper Container
FROM ubuntu:14.04
COPY install/zookeeper-3.4.6.tar.gz /
RUN tar -xf zookeeper-3.4.6.tar.gz && rm zookeeper-3.4.6.tar.gz
ENV ZOOKEEPER_HOME /zookeeper-3.4.6
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
RUN mkdir -p /var/lib/zookeeper
COPY conf/zoo.cfg /zookeeper-3.4.6/conf/
COPY conf/3 /var/lib/zookeeper/my_id
EXPOSE 2181
EXPOSE 2888
EXPOSE 3888
WORKDIR /zookeeper-3.4.6

