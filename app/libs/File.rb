module Skymod
	class ModFile
		attr_reader	:type
		attr_reader	:destination
		attr_accessor	:source
		attr_accessor	:priority
		attr_accessor	:base

		def initialize(input)
			if input.is_a?(String)
				@type = :file
				@source = input
				@destination = ""
				@priority = 1
			else
				if input.name == "folder"
					@type = :folder
				elsif input.name == "file"
					@type = :file
				end
				@source = input.attributes['source']
				@destination = input.attributes['destination']
				@priority = input.attributes['priority']
			end
		end
	end
end
