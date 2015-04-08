include_recipe "pod_manager::create-images"
#include_recipe "pod_manager::static-dockerfiles"  # workaround for lack of a valid CA for signing certificates
include_recipe "pod_manager::configure-pods"
include_recipe "pod_manager::start-pods"
#include_recipe "pod_manager::update-pods" # should be moved to the kubernetes minion?