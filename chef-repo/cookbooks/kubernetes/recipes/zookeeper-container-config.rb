#Build the zookeeper image

zookeeper_count = 1
node[:kubernetes][:pods][:zookeeper][:quorum_size].times do
	# Create the docker context for this particular zookeeper container
	remote_directory "/etc/kubernetes/docker_contexts/zookeeper-#{zookeeper_count}" do
		source "docker_contexts/zookeeper"		
		recursive true
		action :create
	end

	# Create any files the dockerfile depends on
	# zoo.cfg
	template "/etc/kubernetes/docker_contexts/zookeeper-#{zookeeper_count}/conf/zoo.cfg" do
		source "docker_contexts/zookeeper/conf/zoo.cfg.erb"
		mode '0400'
		owner 'root'
		group 'root'
		variables({
			:tick_dir => node[:kubernetes][:containers][:zookeeper][:tick_time],
			:data_dir => node[:kubernetes][:containers][:zookeeper][:data_dir],
			:client_port => node[:kubernetes][:containers][:zookeeper][:client_port],
			:init_limit => node[:kubernetes][:containers][:zookeeper][:init_limit],
			:sync_limit => node[:kubernetes][:containers][:zookeeper][:sync_limit],
			:quorum_size => node[:kubernetes][:pods][:zookeeper][:quorum_size],
			:container_hostname_base => node[:kubernetes][:pods][:zookeeper][:replication_controller][:v1beta3][:spec][:template][:spec][:containers][0][:name]
		})
		action :create
	end

	# my_id
	file "/etc/kubernetes/docker_contexts/zookeeper-#{zookeeper_count}/conf/my_id" do
		content "#{zookeeper_count}"
		action :create
	end
	
	execute 'zookeeper-#{zookeeper_count}-build' do
		command "docker build -t zookeeper-#{zookeeper_count} /etc/kubernetes/docker_contexts/zookeeper-#{zookeeper_count}"
		not_if "docker images | grep zookeeper-#{zookeeper_count}"
	end

	zookeeper_count += 1
end
