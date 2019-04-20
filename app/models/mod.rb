require 'rexml/document'

module Skymod
	class ModNotFoundException < StandardError
	end

	class Mod
		attr_accessor :archive
		attr_accessor :installed
		attr_accessor :modId

		def initialize(filename, db, app_root, gameId)
			@archive = Archive.new(app_root, filename)
			@db = db
			@gameId = gameId
			@installed = "false"
		end

		def save!
			name = File.basename(@archive.filename)
			@db.execute("INSERT INTO mods(archive_name, installed, gameId) VALUES (?, ?, ?)", name, @installed, @gameId)
		end

		def update_installed!
			@db.execute("UPDATE mods SET installed = (?) WHERE rowid == (?)", @installed, @modId)
		end

		def exists?
			if @db.execute("SELECT * FROM mods WHERE archive_name == (?)", File.basename(@archive.filename)).empty?
				return false
			elsif @db.execute("SELECT * FROM games WHERE rowid == (?)", @gameId).empty?
				return false
			else
				return true
			end
		end

		def extract!
			@archive.extract
		end

		def install!
			return if @installed == "true"
			game_dir = @db.execute("SELECT path FROM games WHERE rowid == (?)", @gameId).first.first
			fomod_dir = Skymod::Dir.no_case_find(@archive.base_extract_dir, "fomod")
			if fomod_dir
				module_config_xml_path = Skymod::Dir.no_case_find(fomod_dir, "ModuleConfig.xml")
				module_config_xml = REXML::Document.new(File.open(module_config_xml_path))
				installer = Skymod::FomodInstaller.new(game_dir, module_config_xml, @archive.base_extract_dir, @db, @modId)
			else
				installer = Skymod::DirectInstaller.new(game_dir, @archive.base_extract_dir, @db, @modId)
			end

			installer.prepare.run
			@installed = "true"
			self.update_installed!
		end

		def uninstall!
			return if @installed == "false"
			raise ModNotFoundException if @modId.nil? 
			data_dir = Skymod::Dir.no_case_find(game_dir, "Data")
			files = @db.execute("SELECT path FROM mod_files WHERE modId == (?)", @modId)
			files.each do |file|
				File.delete(File.join(data_dir, file.first)) if file.first
			end
			@installed = "false"
		end
	end
end
