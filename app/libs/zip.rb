module Skymod
	class ExtractorZip
		def initialize
		end

		def extract(base_extract_dir, filename)
			system("unzip \"#{filename}\" -d \"#{base_extract_dir}\"")
		end
	end
end
