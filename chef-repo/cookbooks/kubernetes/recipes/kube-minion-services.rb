# kube-minion-services.rb

node['kubernetes']['kube_minion_services'].each do |kube_minion_service|
	service kube_minion_service do
		action [ :restart, :enable ]
	end
end