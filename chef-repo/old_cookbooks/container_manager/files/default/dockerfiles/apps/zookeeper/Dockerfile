# Apache Zookeeper Container
FROM chef_base
# Configure runit for zookeeper
RUN mkdir -p /etc/service/chef-client
COPY service/chef-client/run /etc/service/chef-client/run
# Configure chef-client
COPY chef /etc/chef
# Start runit services
CMD ["/sbin/my_init"]
