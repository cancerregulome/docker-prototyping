# Apache Solr Container
FROM ubuntu:14.04
COPY install/solr-4.10.3.tar /
RUN tar -xf solr-4.10.3.tar && rm solr-4.10.3.tar
RUN apt-get -qq update && apt-get -qq install openjdk-7-jdk openjdk-7-jre && apt-get -qq clean
# Create directories
# Copy config files
# Environment variables
# Create the solr user to run the container
# Create the solr user's home directory contents 
EXPOSE 7574
EXPOSE 8983
