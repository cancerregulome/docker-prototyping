# Apache Zookeeper Container
FROM chef_base
# Configure supervisor for zookeeper
RUN mkdir -p /var/log/supervisor
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
# Configure chef-client
COPY chef /etc/chef
# Install and configure zookeeper
#COPY install/zookeeper-3.4.6.tar.gz /
#RUN tar -xf zookeeper-3.4.6.tar.gz && rm zookeeper-3.4.6.tar.gz
#ENV ZOOKEEPER_HOME /zookeeper-3.4.6
#RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
#RUN mkdir -p /var/zookeeper
#COPY config/zoo.cfg /zookeeper-3.4.6/conf/
#COPY config/myid /var/zookeeper/myid
#EXPOSE 2181
#EXPOSE 2888
#EXPOSE 3888
CMD ["/usr/bin/supervisord"]
