docker_container 'docker-registry' do
	image 'samalba/docker-registry'
	detach true
	hostname 'docker-registry.example.com'
	port '5000:5000'
	env 'SETTINGS_FLAVOR=local'
	volume '/mnt/docker:/docker-storage'
end