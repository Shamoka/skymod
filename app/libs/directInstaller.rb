module Skymod
	class DirectInstaller < Installer
		def initialize(game, mod, db)
			super(game, mod, db)
			@data_dir = Skymod::Dir.no_case_find(@root, "data")
			@data_dir = @root if @data_dir.nil?
		end

		def prepare
			add_files_to_list(@data_dir, ".", 0)
			return self
		end

		def run
			copy_files(@data_dir)
		end
	end
end
