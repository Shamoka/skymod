module Skymod
	class Game
		attr_reader	:path
		attr_reader	:name
		attr_accessor	:id

		def initialize(name, path, db)
			@name = name
			@path = path
			@db = db
		end

		def exists?
			not @db.execute("SELECT * FROM games
							WHERE name == (?)
							AND path == (?)").empty?
		end

		def save!
			@db.execute("INSERT INTO games(name, path)
						VALUE((?), (?))", @name, @path)
		end

		def mods
			mods = Array.new
			@db.execute("SELECT *, rowid FROM mods WHERE gameId == (?)", @id).each do |row|
				mod = Mod.new(row[0], @db, @id)
				mod.installed = row[1]
				mod.modId = row[3]
				mods << mod
			end
			return mods
		end
	end
end
