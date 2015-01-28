name "webserver"
description "The webserver that will run on SolrCloud hosts"
run_list "recipe[tomcat]", "recipe[tomcat::configure_tomcat]", "recipe[tomcat::start_tomcat]"

