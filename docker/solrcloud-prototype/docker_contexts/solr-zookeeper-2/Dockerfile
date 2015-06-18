# Apache Zookeeper Container
FROM ubuntu:14.04
ENV ZOOKEEPER_HOME /zookeeper-3.4.6
ENV ZOOKEEPER_CONF /zookeeper-3.4.6/conf
ENV ZOOKEEPER_DATA_DIR /zookeeper-3.4.6/data
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
COPY install/zookeeper-3.4.6.tar.gz /
COPY conf/zoo.cfg /zookeeper-3.4.6/conf/zoo.cfg
COPY conf/myid /zookeeper-3.4.6/data/myid
RUN tar -xf zookeeper-3.4.6.tar.gz && rm zookeeper-3.4.6.tar.gz
RUN mkdir -p /zookeeper-3.4.6/data
RUN mkdir -p /zookeeper-3.4.6/startup
EXPOSE 2182
EXPOSE 2889
EXPOSE 3889
WORKDIR /zookeeper-3.4.6
CMD ["java", "-cp", "$ZOOKEEPER_HOME/zookeeper-3.4.6.jar:$ZOOKEEPER_HOME/lib/slf4j-api-1.7.5.jar:$ZOOKEEPER_HOME/lib/slf4j-log4j12-1.7.5.jar:$ZOOKEEPER_HOME/lib/log4j-1.2.16.jar:$ZOOKEEPER_CONF/conf", "org.apache.zookeeper.server.quorum.QuorumPeerMain", "$ZOOKEEPER_CONF/zoo.cfg"]
