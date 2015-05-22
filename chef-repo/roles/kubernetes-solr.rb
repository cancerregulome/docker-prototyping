# Kubernetes-Solr Role Definition
# Prepares the resources needed by the kubernetes master to create a SolrCloud cluster
# Starts all Kubernetes pods/services/replication controllers associated with the role after configuration

name "kubernetes-master"
description "The kubernetes master node role"
run_list "recipe[roles::kubernetes-solr]"
