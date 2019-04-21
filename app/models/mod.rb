require 'rexml/document'

module Skymod
	class ModNotFoundException < StandardError
	end

	class Mod
		attr_accessor :archive
		attr_accessor :installed
		attr_accessor :id
		attr_accessor :name

		def initialize(filename, db, gameId)
			@archive = Archive.new($app_root, filename)
			@name = File.basename(filename, File.extname(filename))
			@db = db
			@gameId = gameId
			@installed = "false"
		end

		def save!
			@db.execute("INSERT INTO mods(archive_name, installed, gameId) 
						VALUES (?, ?, ?)", 
						File.basename(@archive.filename), @installed, @gameId)
		end

		def update_installed!
			@db.execute("UPDATE mods 
						SET installed = (?) 
						WHERE rowid == (?)", 
						@installed, @id)
		end

		def exists?
			not @db.execute("SELECT * FROM mods 
							WHERE archive_name == (?) 
							AND gameId == (?)", 
							File.basename(@archive.filename), @gameId).empty?
		end

		def install!
			return if @installed == "true"
			game = @db.get_game(@gameId)
			fomod_dir = Skymod::Dir.no_case_find(@archive.base_extract_dir, "fomod")
			if fomod_dir
				module_config_xml_path = Skymod::Dir.no_case_find(fomod_dir, "ModuleConfig.xml")
				module_config_xml = REXML::Document.new(File.open(module_config_xml_path))
				installer = Skymod::FomodInstaller.new(game, self, @db, module_config_xml)
			else
				installer = Skymod::DirectInstaller.new(game, self, @db)
			end

			installer.prepare.run
			@installed = "true"
			update_installed!
		end

		def uninstall!
			return if @installed == "false"
			raise ModNotFoundException if @id.nil? 
			game = @db.get_game(@gameId)
			get_files.each do |file|
				File.delete(File.join(game.data_dir, file['path']))
				@db.execute("DELETE FROM mod_files WHERE rowid == (?)", file['rowid'])
			end
			@installed = "false"
			update_installed!
		end

		private

		def get_files
			@db.execute("SELECT *, rowid FROM mod_files WHERE modId == (?)", @id)
		end
	end
end
