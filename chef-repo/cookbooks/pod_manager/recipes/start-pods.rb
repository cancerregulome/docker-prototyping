# kubernetes::start-pods.rb

# Start all pods with a configuration on the kubernetes master
# NOTE:  Consider creating a pod lwrp in this cookbook!

node[:pods][:definitions].each do |definition|
	execute "kubernetes_resource" do
		command "kubectl create -f #{definition}"
	end
end
