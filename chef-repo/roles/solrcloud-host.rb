name "solrcloud-host"
description "The host that will run an instance of Zookeeper, a Solr collection, and Tomcat webserver inside individual docker containers."
run_list "recipe[solrcloud]", "recipe[solrcloud::configure_containers]", "recipe[solrcloud::start_containers]"
