#include_recipe "docker"

chef_gem "chef-provisioning-docker" do
	compile_time false if respond_to?(:compile_time)
	action :install
end
