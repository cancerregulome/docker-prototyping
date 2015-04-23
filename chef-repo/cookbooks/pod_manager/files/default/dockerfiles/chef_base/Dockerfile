# Abby's Chef Container ;)
FROM ubuntu:14.04
#MAINTAINER Institute for Systems Biology <ahahn@systemsbiology.org>
# Install and configure chef-client and supervisor
RUN apt-get -yqq update
RUN apt-get -yqq install curl supervisor
RUN curl -L https://www.chef.io/chef/install.sh | sudo bash

