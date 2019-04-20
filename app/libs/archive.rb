#!/usr/bin/env ruby

module Skymod
	class Archive
		attr_accessor :filename
		attr_accessor :base_extract_dir

		def initialize(app_root, filename)
			@filename = filename
			@base_extract_dir = File.join("data", "dump", File.basename(filename))
			@extractor = Extractor.new(app_root, filename, @base_extract_dir)
		end

		def extract
			@extractor.extract
		end
	end
end
