#kubernetes::start-services
node[:kubernetes][:services].each do |service|
	definition = service[:v1beta1][:definition]
	execute "kubernetes_service" do
		command "kubectl create -f #{definition}"
		not_if "kubectl get service #{service[:v1beta1][:metadata][:name]}" 
	end
end
