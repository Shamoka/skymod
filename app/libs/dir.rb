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

		def self.find_dir_no_case(base_dir, case_dir)
			result = base_dir + "/"
			case_dir.split('\\').each do |dir|
				target = Dir.no_case_find(result, dir)
				if target and File.directory?(target)
					result << File.basename(target)
					result << "/"
				else
					return nil
				end
			end
			return result
		end
	end
end
