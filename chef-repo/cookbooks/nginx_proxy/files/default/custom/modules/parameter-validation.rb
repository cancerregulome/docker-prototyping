require 'etc'

module ParameterValidation
	def self.owner_exists?(owner)
		result = true
		begin
			Etc.getpwnam(owner)
		rescue
			result = false
		end
		
		return result
	end

	def self.group_exists?(group)
		result = true
		begin
			Etc.getgrnam(group)
		rescue
			result = false
		end

		return result

	end

	def self.valid_file_mode?(mode)
		result = true
		# each of the four bits must be a sum of any of 4(read), 2(write), 1(execute), or be equal to 0.
		mode.each_byte do |bit|
			if bit.chr.to_i < 0 || bit.chr.to_i > 7
				result = false
				break
			end
		end
		
		return result
	end	
end