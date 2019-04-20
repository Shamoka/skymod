require 'rexml/document'

module Skymod
	class ModNotFoundException < StandardError
	end

	class Mod
		attr_accessor :archive
		attr_accessor :installed

		def initialize(filename, db, app_root)
			@archive = Archive.new(app_root, filename)
			@installed = false
			@db = db
			@modId = @db.execute("SELECT DISTINCT rowid FROM mods WHERE archive_name == (?)", File.basename(@archive.filename))
			@modId = @modId.first
		end

		def save!
			name = File.basename(@archive.filename)
			ret = @db.execute("INSERT INTO mods(archive_name, installed) VALUES (?, ?)", name,  @installed.to_s)
			@modId = @db.execute("SELECT DISTINCT rowid FROM mods WHERE archive_name == (?)", name).first.first
			raise ModNotFoundException if @modId.nil?
		end

		def exists?
			if @db.execute("SELECT * FROM mods WHERE archive_name == (?)", File.basename(@archive.filename)).empty?
				return false
			else
				return true
			end
		end

		def extract!
			@archive.extract
		end

		def install!(game_dir)
			fomod_dir = Skymod::Dir.no_case_find(@archive.base_extract_dir, "fomod")
			if fomod_dir
				module_config_xml_path = Skymod::Dir.no_case_find(fomod_dir, "ModuleConfig.xml")
				module_config_xml = REXML::Document.new(File.open(module_config_xml_path))
				installer = Skymod::FomodInstaller.new(game_dir, module_config_xml, @archive.base_extract_dir, @db, @modId)
			else
				installer = Skymod::DirectInstaller.new(game_dir, @archive.base_extract_dir, @db, @modId)
			end

			installer.prepare.run
		end

		def uninstall!(game_dir)
			raise ModNotFoundException if @modId.nil? 
			data_dir = Skymod::Dir.no_case_find(game_dir, "Data")
			files = @db.execute("SELECT path FROM mod_files WHERE modId == (?)", @modId)
			files.each do |file|
				File.delete(File.join(data_dir, file.first)) if file.first
			end
			@db.execute("DELETE FROM mod_files WHERE modId == (?)", @modId)
		end
	end
end
