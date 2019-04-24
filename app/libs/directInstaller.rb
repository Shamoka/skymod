module Skymod
	class DirectInstaller < Installer
		def initialize(game, mod, db)
			super(game, mod, db)
			@data_dir = nil
		end

		def prepare
			if not @data_dir = Skymod::Dir.no_case_find(@game.path,  "Data")
				@data_dir = File.join(@game.path, "Data")
				Dir.mkdir(@data_dir)
			end

			add_folder_to_files("", "", 0)
			return true
		end

		def run
			copy_files(@data_dir)
		end
	end
end
