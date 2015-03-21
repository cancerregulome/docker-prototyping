# kube-install.rb

# Create the repo from a cookbook file

case node[:platform]
when "centos", "redhat"
	cookbook_file "virt7-testing.repo" do
		path "/etc/yum.repos.d/virt7-testing.repo"
		mode 00644
	end

	yum_package 'kubernetes' do
		action :install
		flush_cache [:before]
		options "--enablerepo=virt7-testing"
	end
end

# Try using the docker cookbook to update the docker installation for chef 
node.override['docker']['options'] = "--insecure-registry #{node[:hostname]}:443"
include_recipe "docker"
