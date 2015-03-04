# Include all recipes in the pods cookbook
# It would be awesome if I could iterate through all of the recipes in a cookbook to include,
# that way if any new pods are created this file won't need to be updated.  Until then, just
# list them out.

include_recipe "pods::zookeeper"
include_recipe "pods::solr"
