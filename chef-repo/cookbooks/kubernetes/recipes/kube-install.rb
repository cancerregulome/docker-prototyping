# kube-install.rb

# Create the repo from a cookbook file

case node[:platform]
when "centos", "redhat"
	cookbook_file "virt7-testing.repo" do
		path "/etc/yum.repos.d/virt7-testing.repo"
		mode 00644
	end

	package 'kubernetes' do
		action :install
		flush_cache[:before]
		options "--enablerepo=virt7-testing"
	end
end
