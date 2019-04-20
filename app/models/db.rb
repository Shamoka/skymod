module Skymod 
	class DB
		def initialize(app_root, game_dir)
			@db = SQLite3::Database.new(File.join(app_root, "data", "mods.db"))
			@app_root = app_root
			begin
				@db.execute("SELECT * FROM mods")
			rescue
				@db.execute("CREATE TABLE mods(
							archive_name VARCHAR(1024) NOT NULL,
							installed BOOL)")
				@db.execute("CREATE TABLE mod_files(
							modId INT(64),
							path VARCHAR(2048),
							FOREIGN KEY(modId) REFERENCES mods(rowid))")
			end
			check_archives(game_dir, File.join(app_root, "data", "archives"))
		end

		def execute(cmd)
			@db.execute(cmd)
		end

		private

		def check_archives(game_dir, archive_dir)
			Dir.glob(File.join(archive_dir, "*.7z")).each do |archive_file|
				mod = Mod.new(archive_file, @db, @app_root)
				if not mod.exists?
					mod.save!
					mod.extract!
				end
				mod.install!(game_dir)
			end
		end
	end
end
