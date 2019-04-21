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
			end
		end

		def initialize(application)
			super application: application

			set_title 'Skymod'
			load_modules(application)

			menuQuit.signal_connect :activate do |widget|
				application.quit
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

		def load_modules(application)
			modListBox.children.each do |child|
				modListBox.remove child
			end
			application.db.get_game(1).mods.each do |mod|
				modListBox.add(Skymod::ListBoxRow.new(mod))
			end
		end
	end
end
