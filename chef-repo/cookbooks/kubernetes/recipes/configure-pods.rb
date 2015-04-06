# kubernetes::configure_pods.rb

# Configure all pods
include_recipe "pods"
include_recipe "pods::zookeeper"
#include_recipe "pods::solr"