# Authenticate to GCP to push images to the private CGC registry
execute 'gcloud_auth_login' do
	command 'gcloud auth login ahahn@systemsbiology.org --no-launch-browser --project isb-cgc -q'
	action :run
end

# Copy the chef docker context to the node
remote_directory "/etc/kubernetes/pods/dockerfiles" do
	source "dockerfiles"
	recursive true
	action :create
end

# Build the chef base image first
docker_image 'chef_base' do
	source "/etc/kubernetes/pods/dockerfiles/chef_base/Dockerfile"
	tag "gcr.io/isb_cgc/chef_base"
	action :build_if_missing
	notifies :run, 'execute[gcloud_push_base]', :immediately
end

# Push the chef base to the google container registry
execute 'gcloud_push_base' do
	command 'gcloud preview docker push gcr.io/isb_cgc/chef_base'
	action :nothing
end

# Build/tag/push the rest of the images
Dir.foreach('/etc/kubernetes/pods/dockerfiles/apps') do |context_name|
	docker_image "#{context_name}" do
		source "/etc/kubernetes/pods/dockerfiles/apps/#{context_name}/Dockerfile"
		tag "gcr.io/isb_cgc/#{context_name}"
		action :build_if_missing
		notifies :run, 'execute[gcloud_push_app]', :immediately
	end
	
	execute 'gcloud_push_app' do
		command "gcloud preview docker push gcr.io/isb_cgc/#{context_name}"
		action :nothing
	end
end





