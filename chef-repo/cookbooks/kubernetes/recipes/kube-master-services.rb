# kube-master-services.rb

# Start up the services
node['kubernetes']['kube_master_services'].each do |kube_master_service|
	service kube_master_service do
		action [ :restart, :enable ]
	end
end
