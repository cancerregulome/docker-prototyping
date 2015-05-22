include_recipe "kubernetes::zookeeper-container-config.rb"
include_recipe "kubernetes::zookeeper-rc-config.rb"
include_recipe "kubernetes::zookeeper-service-config.rb"
include_recipe "kubernetes::start-services.rb"
include_recipe "kubernetes::start-replication-controllers.rb"

