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

			if base_dir = Skymod::Dir.no_case_find(@root, "Data")
				add_folder_to_files(File.basename(base_dir), File.basename(base_dir), 0)
			else
				add_folder_to_files("", "", 0)
			end

			return true
		end

		def run
			copy_files(@data_dir)
		end
	end
end
