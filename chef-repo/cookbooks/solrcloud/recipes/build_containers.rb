require 'pathname'

# Build the containers (3 steps)
Dir.glob("/dockerfiles/**").each do |docker_context|
	container_name = Pathname.new(docker_context).basename
	execute "docker build -t #{container_name} #{docker_context}"
end




