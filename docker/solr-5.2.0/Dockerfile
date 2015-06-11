FROM ubuntu:14.04
# Copy the installation files to the container
COPY install/solr-5.2.0.zip /solr-5.2.0.zip
RUN tar -xf /solr-5.2.0.zip
# Copy configuration files to the container
COPY config/.. ?
# Copy the setup script to the container
COPY setup/configure-automount.sh /tmp/configure-automount.sh
COPY setup/solr-startup.sh /tmp/solr-startup.sh
# External volumes -- reference only, will be defined in pod spec
# VOLUME /var/solr/data
# Expose service ports -- reference only, will be defined in pod spec
# EXPOSE 8983
# Set up the environment -- reference only, will be set in the startup script
# SOLR_HOME=/var/solr/data
# Run the startup script -- reference only, will be defined in the pod spec
# ENTRYPOINT ["/tmp/solr-startup.sh"]
