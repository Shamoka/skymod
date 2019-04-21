module Skymod
	class ApplicationWindow < Gtk::ApplicationWindow
		type_register

		class << self
			def init
				set_template resource: "/org/shamoka/skymod/ui/ApplicationWindow.ui"

				bind_template_child 'modListBox'
				bind_template_child 'menuAddGame'
				bind_template_child 'menuChooseGame'
				bind_template_child 'menuQuit'
				bind_template_child 'menuGameList'
			end
		end

		def initialize(application)
			super application: application

			set_title 'Skymod'

			load_modules(application)

			menuQuit.signal_connect :activate do |widget|
				application.quit
			end

			menuChooseGame.signal_connect :activate do |widget|
				load_games(application)
			end

			menuAddGame.signal_connect :activate do |widget|
				dialog = Skymod::AddGameDialog.new
				if dialog.run == Gtk::ResponseType::OK
					game = Game.new(dialog.name, dialog.path, application.db)
					game.save! if not game.exists?
				end
				dialog.destroy
			end
		end

		private

		def load_games(application)
			menuGameList.children.each do |child|
				menuGameList.remove child
			end

			application.db.games.each do |game|
				menuItem = Skymod::GameListMenuItem.new(game)
				menuItem.signal_connect :activate do |widget|
					application.current_game = widget.game.id
					load_modules(application)
				end
				menuGameList.add(menuItem)
			end
		end

		def load_modules(application)
			modListBox.children.each do |child|
				modListBox.remove child
			end
			if not application.current_game.nil?
				application.db.get_game(application.current_game).mods.each do |mod|
					modListBox.add(Skymod::ListBoxRow.new(mod))
				end
			end
		end
	end
end
