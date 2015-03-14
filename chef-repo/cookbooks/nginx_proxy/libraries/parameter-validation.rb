require 'etc'

class Chef
	class Resource::NginxProxyParameterValidation
		def owner_exists?(owner)
			result = true
			begin
				Etc.getpwnam(owner)
			rescue
				result = false
			end
			
			return result
		end

		def group_exists?(group)
			result = true
			begin
				Etc.getgrgid(group)
			rescue
				result = false
			end

			return result

		end

		def valid_file_mode?(mode)
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
end