# Abby's Chef Container ;)
FROM phusion/baseimage:latest
#MAINTAINER Institute for Systems Biology <ahahn@systemsbiology.org>
# Install and configure chef-client and runit
RUN apt-get -yqq update
RUN apt-get -yqq install curl
RUN curl -L https://www.chef.io/chef/install.sh | sudo bash
RUN mkdir -p /etc/service/chef-client
COPY service/chef-client/run /etc/service/chef-client/run
# Configure chef-client
COPY chef /etc/chef
# Start runit services
CMD ["/sbin/my_init"]


