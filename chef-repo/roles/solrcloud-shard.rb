name "solrcloud-shard"
description "A container that will run an instance of a SolrCloud shard."
run_list "recipe[solrcloud::configure_shard]", "recipe[solrcloud-shard::start_shard]"
