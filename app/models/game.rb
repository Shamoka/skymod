module Skymod
	class Game
		attr_reader	:path
		attr_reader	:name
		attr_reader :data_dir
		attr_accessor	:id

		def initialize(name, path, db)
			@name = name
			@path = path
			@db = db
			@data_dir = Skymod::Dir.no_case_find(@path, "Data")
		end

		def exists?
			not @db.execute("SELECT * FROM games
							WHERE name == (?)
							AND path == (?)").empty?
		end

		def save!
			@db.execute("INSERT INTO games(name, path)
						VALUES(?, ?)", @name, @path)
		end

		def mods
			mods = Array.new
			@db.execute("SELECT *, rowid 
						FROM mods 
						WHERE gameId == (?)", @id) do |row|
				mod = Mod.new(row['archive_name'], @db, @id)
				mod.installed = row['installed']
				mod.id = row['rowid']
				mods << mod
			end
			return mods
		end
	end
end
