module Skymod
	class Extractor
		class InvalidFileType < StandardError
		end

		def initialize(app_root, filename, base_extract_dir)
			@base_extract_dir = base_extract_dir 
			@app_root = app_root
			@filename = filename

			if File.extname(filename) == ".7z"
				@extractor = Extractor7z.new
			elsif File.extname(filename) == ".zip"
				@extractor = ExtractorZip.new
			else
				raise InvalidFileType
			end
		end

		def extract
			@extractor.extract(@base_extract_dir, @filename)
		end
	end
end
