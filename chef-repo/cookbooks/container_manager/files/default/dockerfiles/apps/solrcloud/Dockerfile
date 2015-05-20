# Apache Solr (SolrCloud) Container
FROM chef_base
# Configure supervisor for solr
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Configure chef-client
COPY chef /etc/chef

