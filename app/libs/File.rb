module Skymod
	class ModFile
		attr_reader	:type
		attr_reader	:source
		attr_reader	:destination
		attr_reader	:priority

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
