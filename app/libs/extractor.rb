module Skymod
	class Extractor
		class InvalidFileType < StandardError
		end

		def initialize(app_root, filename, base_extract_dir)
			@base_extract_dir = base_extract_dir 
			@app_root = app_root
			@filename = filename

			if (/.*\.7z/ =~ filename)
				@extractor = Extractor7z.new
			else
				raise InvalidFileType
			end
		end

		def extract
			@extractor.extract(@base_extract_dir, @filename)
		end
	end
end
