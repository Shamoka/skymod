module Skymod 
	class DB
		def initialize(app_root)
			@db = SQLite3::Database.new(File.join(app_root, "data", "mods.db"))
			@app_root = app_root
			begin
				@db.execute("SELECT * FROM mods")
			rescue
				@db.execute("CREATE TABLE games(
							 name VARCHAR(256),
							 path VARCHAR(2048))")
				@db.execute("CREATE TABLE mods(
							archive_name VARCHAR(1024) NOT NULL,
							installed BOOL,
							gameId INT(64),
							FOREIGN KEY(gameId) REFERENCES games(rowid))")
				@db.execute("CREATE TABLE mod_files(
					modId INT(64),
							path VARCHAR(2048),
							FOREIGN KEY(modId) REFERENCES mods(rowid))")
				@db.execute("INSERT INTO games(name, path) VALUES('test', './tmp')")
			end
			check_archives(File.join(app_root, "data", "archives", "test"))
		end

		def execute(cmd)
			@db.execute(cmd)
		end

		def all_mods_for_game(gameId)
			mods = Array.new
			@db.execute("SELECT *, rowid FROM mods WHERE gameId == (?)", gameId).each do |row|
				mod = Mod.new(row[0], @db, @app_root, gameId)
				mod.installed = row[1]
				mod.modId = row[3]
				mods << mod
			end
			return mods
		end

		private

		def check_archives(archive_dir)
			game = File.basename(archive_dir)
			gameId = @db.execute("SELECT DISTINCT rowid FROM games WHERE name == (?)", game).first.first
			Dir.glob(File.join(archive_dir, "*.7z")).each do |archive_file|
				mod = Mod.new(archive_file, @db, @app_root, gameId)
				if not mod.exists?
					mod.save!
					mod.extract!
				end
			end
		end
	end
end
