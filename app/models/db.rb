module Skymod 
	class DB
		def initialize
			@db = SQLite3::Database.new(File.join($app_root, "data", "mods.db"))
			@db.results_as_hash = true
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
			end
		end

		def execute(*cmd)
			if block_given?
				@db.execute(*cmd) do |row|
					yield row
				end
			else 
				@db.execute(*cmd)
			end
		end

		def games
			games = Array.new
			@db.execute("SELECT *, rowid FROM games").each do |game_sql|
				game = Game.new(game_sql['name'], game_sql['path'], self)
				game.id = game_sql['rowid']
				games << game
			end
			return games
		end

		def get_game(gameId)
			game_sql = @db.execute("SELECT *, rowid
								   FROM games
								   WHERE rowid == (?)", gameId).first
			game = Game.new(game_sql['name'], game_sql['path'], self)
			game.id = game_sql['rowid']
			return game
		end

		private

	end
end
