# kubernetes::start-pods.rb

# Start all pods with a configuration on the kubernetes master
# NOTE:  Consider creating a pod lwrp in this cookbook!

node[:kubernetes][:replication_controllers].each do |rc|
	definition = rc[:v1beta3][:definition]

	execute "kubernetes_rc" do
		command "kubectl create -f #{definition}"
		not_if "kubectl get replicationcontroller #{rc[:v1beta3][:metadata][:name]}"
	end
end
