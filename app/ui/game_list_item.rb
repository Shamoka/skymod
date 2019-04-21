module Skymod
	class GameListMenuItem < Gtk::MenuItem
		type_register

		attr_reader	:game

		def initialize(game)
			super()

			@game = game
			self.label = game.name
			self.visible = true
		end
	end
end
