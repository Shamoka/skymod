module Skymod
	attr_accessor :installed_files

	class Installer
		def initialize(game, mod, db)
			@installed_files = Array.new
			@game = game
			@root = mod.archive.base_extract_dir
			@db = db
			@modId = mod.id
			@files_list = Array.new
		end

		private

		def create_directory_hierarchy(dest_dir, file)
			dirs = Array.new
			while (file = File.dirname(file)) != "."
				dirs << file
			end
			dirs.sort!.each do |dir|
				if not target = Skymod::Dir.no_case_find(dest_dir, File.basename(dir))
					target = File.basename(dir)
				end
				dest_dir = File.join(dest_dir, File.basename(target))
				Dir.mkdir(dest_dir) if not File.exists?(dest_dir)
			end
			dest_dir
		end

		def copy_files(dest_dir)
			@installed_files.each do |file|
				real_dir = create_directory_hierarchy(dest_dir, file.source)
				FileUtils.cp(File.join(@root, file.base, file.source), real_dir)
				@db.execute("INSERT INTO mod_files(modId, path) VALUES(?, ?)", @modId,
												File.join(real_dir.delete_prefix(dest_dir + '/'), 
														  File.basename(file.source)))
			end
		end

		def add_folder_to_files(base, dir, priority)
			full_path = File.join(@root, dir)
			Dir.entries(full_path).each do |file|
				if file != '.' and file != '..'
					file_path = File.join(full_path, file)
					if File.directory?(file_path)
						add_folder_to_files(base, File.join(dir, file), priority)
					else
						new_file = Skymod::ModFile.new(File.join(dir, file).delete_prefix(base + '/'))
						new_file.base = base
						new_file.priority = priority
						@installed_files << new_file
					end
				end
			end
		end
	end
end
