module Skymod
	attr_accessor :installed_files

	class Installer
		def initialize(game, mod, db)
			@installed_files = Array.new
			@game_dir = game.path
			@root = mod.archive.base_extract_dir
			@db = db
			@modId = mod.id
		end

		private

		def create_directory_hierarchy(dest_dir, file)
			dirs = Array.new
			while (file = File.dirname(file)) != "."
				dirs << file
			end
			dirs.sort.each do |dir|
				if not target = Skymod::Dir.no_case_find(dest_dir, File.basename(dir))
					target = File.basename(dir)
				end
				dest_dir = File.join(dest_dir, File.basename(target))
				Dir.mkdir(dest_dir) if not File.exists?(dest_dir)
			end

		end

		def copy_files(base_dir)
			if not dest_dir = Skymod::Dir.no_case_find(@game_dir,  "Data")
				dest_dir = File.join(@game_dir, "Data")
				Dir.mkdir(dest_dir)
			end
			@installed_files.sort.each do |file|
				file_no_prefix = file.delete_prefix(base_dir + '/')
				create_directory_hierarchy(dest_dir, file_no_prefix)
				FileUtils.cp(file, File.join(dest_dir, file_no_prefix))
				@db.execute("INSERT INTO mod_files(modId, path) VALUES(?, ?)", @modId, file_no_prefix)
			end
		end

		def add_files_to_list(base_dir, dir)
			Dir.children(dir).each do |child|
				file = File.join(dir, child)
				if (File.directory?(file))
					add_files_to_list(base_dir, file)
				else
					@installed_files << file
				end
			end
		end
	end
end
