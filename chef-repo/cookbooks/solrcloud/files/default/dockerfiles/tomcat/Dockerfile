# BASE chef/ubuntu-12.04:latest
# Apache Tomcat Container
FROM chef/ubuntu-14.04
ADD chef/ /etc/chef/
ONBUILD RUN rm -rf /etc/chef/secure/*
ONBUILD RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre tomcat7 && apt-get -qq clean
ONBUILD EXPOSE 8080
ONBUILD ENTRYPOINT ["chef-init"]
ONBUILD CMD ["--onboot"]
