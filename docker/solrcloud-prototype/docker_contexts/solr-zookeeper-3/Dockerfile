# Apache Zookeeper Container
FROM ubuntu:14.04
ENV ZOOKEEPER_HOME /zookeeper-3.4.6
ENV ZOOKEEPER_CONF /zookeeper-3.4.6/conf
ENV ZOOKEEPER_DATA_DIR /zookeeper-3.4.6/data
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
COPY install/zookeeper-3.4.6.tar.gz /zookeeper-3.4.6.tar.gz
RUN tar -xzf zookeeper-3.4.6.tar.gz && rm /zookeeper-3.4.6.tar.gz
RUN mkdir -p /zookeeper-3.4.6/data
COPY conf/zoo.cfg /zookeeper-3.4.6/conf/zoo.cfg
COPY conf/myid /zookeeper-3.4.6/data/myid
EXPOSE 2183
EXPOSE 2890
EXPOSE 3890
WORKDIR /zookeeper-3.4.6
CMD ["bin/zkServer.sh", "start-foreground"]
