# Upload the repo file and install

case node[:platform]
when "centos", "redhat"
	cookbook_file "nginx.repo" do
		owner 'root'
		group 'root'
		mode '0400'
		path '/etc/yum.repos.d/nginx.repo'
	end

	yum_package 'nginx' do
		action :install
		flush_cache [:before]
		options "--enablerepo=nginx.repo"
	end
end
