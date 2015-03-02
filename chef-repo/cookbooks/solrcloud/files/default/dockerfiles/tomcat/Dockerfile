# BASE chef/ubuntu-12.04:latest
# Apache Tomcat Container
FROM chef/ubuntu-14.04
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre tomcat7 && apt-get -qq clean
EXPOSE 8080
ENTRYPOINT ["chef-init"]
CMD ["--onboot"]
