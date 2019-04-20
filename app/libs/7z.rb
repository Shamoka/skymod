module Skymod
	class Extractor7z
		def initialize
		end

		def extract(base_extract_dir, filename)
			system("7z x -o\"#{base_extract_dir}\" \"#{filename}\"")
		end
	end
end
