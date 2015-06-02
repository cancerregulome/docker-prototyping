# Apache Zookeeper Container
FROM ubuntu:14.04
ENV ZOOKEEPER_HOME /zookeeper-3.4.6
ENV ZOOKEEPER_CONF /zookeeper-3.4.6/conf
ENV ZOOKEEPER_DATA_DIR /zookeeper-3.4.6/data
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre supervisor && apt-get -qq clean
COPY install/zookeeper-3.4.6.tar.gz /
RUN tar -xf zookeeper-3.4.6.tar.gz && rm zookeeper-3.4.6.tar.gz
RUN mkdir -p /zookeeper-3.4.6/data
RUN mkdir -p /zookeeper-3.4.6/startup
COPY startup/zookeeper_startup.sh /zookeeper-3.4.6/startup/zookeeper_startup.sh
EXPOSE 2181
EXPOSE 2888
EXPOSE 3888
WORKDIR /zookeeper-3.4.6
