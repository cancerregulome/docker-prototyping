# nginx-proxy htpasswd file provider

$:.unshift *Dir[::File.expand_path('../../files/default/vendor/gems/**/lib', __FILE__)]

require 'htauth'
require 'fileutils'

def whyrun_supported?
	true
end

action :create do
	if @current_resource.exists
		unless updated_attributes?
			Chef::Log.info "#{ @current_resource } already up-to-date -- nothing to do."
		end
	else
		converge_by("Create nginx htpassword file") do
			new_htpasswd_file
		end
	end
end

action :create_if_missing do
	if @current_resource.exists
		Chef::Log.info "#{ @current_resource } already exists -- nothing to do."
	else
		converge_by("Create nginx htpassword file") do
			new_htpasswd_file
		end
	end
end

action :add_entry do
	if @current_resource.exists
		if not contains_entry?
			converge_by("Adding entry to htpasswd file") do
				add_new_entry
			end
		elsif not @current_resource.user.nil?
			Chef::Log.warn("No user was provided -- no entries will be added!")
		else
			Chef::Log.info "An entry for that user already exists in #{ @current_resource } -- nothing to do."
		end
	else
		Chef::Log.info "#{ @current_resource } doesn't exist -- nothing to do."
	end
end

action :update_entry do
	if @current_resource.exists
		if not contains_entry? 
			Chef::Log.info "No such entry exists in #{ @current_resource } -- nothing to do"
		elsif not @current_resource.user.nil?
			Chef::Log.warn("No user was provided -- no entries will be updated!")
		else
			converge_by("Update entry in htpasswd file") do
				update_existing_entry
			end
		end
	else
		Chef::Log.info "#{ @current_resource } doesn't exist -- nothing to do."
	end
end

action :delete_entry do
	if @current_resource.exists
		if contains_entry?
			converge_by("Delete entry from htpasswd file") do
				delete_existing_entry
			end
		elsif not @current_resource.user.nil?
			Chef::Log.warn("No user was provided -- no entries will be deleted!")
		else
			Chef::Log.info "No such entry exists in #{ @current_resource } -- nothing to do"
		end
	else
		Chef::Log.info "#{ @current_resource } doesn't exist -- nothing to do."
	end
end

action :delete do 
	if @current_resource.exists
		converge_by("Delete nginx htpasswd file") do
			remove_htpasswd_file
		end
	else
		Chef::Log.info "#{ @current_resource } doesn't exist -- nothing to do."
	end
end

def new_htpasswd_file 
	# Creates a new htpasswd file
	htpasswd = HTAuth::PasswdFile.open(@current_resource.path, mode="create")
	
	unless @current_resource.user.nil?
		htpasswd.add(@current_resource.user, @current_resource.password, algorithm="#{@current_resource.encryption_algorithm}")
		htpasswd.save!
	end
	
	# Set permissions
	FileUtils.chmod(@current_resource.mode, @current_resource.path)
	
	# Set ownership
	FileUtils.chown(@current_resource.owner, @current_resource.group, @current_resource.path)
end

def add_new_entry 
	# Adds a new user:password record to the existing htpasswd file
	htpasswd = HTAuth::PasswdFile.open(@current_resource.path, mode="alter")
	htpasswd.add(@current_resource.user, @current_resource.password, algorithm="#{@current_resource.encryption_algorithm}")
	htpasswd.save!
	
	# Set permissions
	FileUtils.chmod(@current_resource.mode, @current_resource.path)
	
	# Set ownership
	FileUtils.chown(@current_resource.owner, @current_resource.group, @current_resource.path)
end

def update_existing_entry 
	# Updates the password for a particular user in the existing htpasswd file
	htpasswd = HTAuth::PasswdFile.open(@current_resource.path, mode="alter")
	htpasswd.update(@current_resource.user, @current_resource.password, algorithm="#{@current_resource.encryption_algorithm}")
	htpasswd.save!
	
	# Set permissions
	FileUtils.chmod(@current_resource.mode, @current_resource.path)
	
	# Set ownership
	FileUtils.chown(@current_resource.owner, @current_resource.group, @current_resource.path)
end

def delete_existing_entry 
	# Deletes an existing user:password record from the existing htpasswd file
	htpasswd = HTAuth::PasswdFile.open(@current_resource.path, mode="alter")
	htpasswd.delete(@current_resource.user)
	htpasswd.save!
	
	# Set permissions
	FileUtils.chmod(@current_resource.mode, @current_resource.path)
	
	# Set ownership
	FileUtils.chown(@current_resource.owner, @current_resource.group, @current_resource.path)
end

def contains_entry? 
	# A wrapper for readability :)
	result = false
	
	if HTAuth::PasswdFile.open(@current_resource.path, mode="alter").has_entry?(@current_resource.user)
		result = true
	end
	
	return result
end

def load_current_resource 
	# Load the resource as defined in the calling recipe
	@current_resource = Chef::Resource::NginxProxyHtpasswordFile.new(@new_resource.name)
	@current_resource.name(@new_resource.name)
	@current_resource.owner(@new_resource.owner)
	@current_resource.group(@new_resource.group)
	@current_resource.mode(@new_resource.mode)
	@current_resource.path(@new_resource.path)
	@current_resource.path(@new_resource.user)
	@current_resource.path(@new_resourc.password)
	
	if File.exists?(@current_resource.path)
		@current_resource.exists = true
	else
		@current_resource.exists = false
	end
end

def updated_attributes?
	# Update the resource attributes on the server, and return true if any were actually changed
	result = false
	
	# Update permissions
	current_mode = sprintf("%o", File.stat(@current_resource.path).mode)
	bits = @current_resource.mode.length
	
	if @current_resource.mode != current_mode[(-1*bits), -1]
		FileUtils.chmod(@current_resource.mode, @current_resource.path)
		result = true
	end
	
	# Update ownership
	current_owner = Etc.getpwuid(File.stat(@current_resource.path).uid).name
	current_group = Etc.getgrgid(File.stat(@current_resource.path).gid).name
	
	if @current_resource.owner != current_owner || @current_resource.group != current_group
		FileUtils.chown(@current_resource.owner, @current_resource.group, @current_resource.path)
		result = true
	end
	
	return result
end
