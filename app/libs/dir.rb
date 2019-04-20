module Skymod
	class Dir < Dir
		def initialize(filename)
			super filename
		end

		def self.no_case_find(current, target)
			Dir.entries(current).each do |entry|
				return File.join(current, entry) if entry.casecmp(target) == 0
			end
			return nil
		end
	end
end
